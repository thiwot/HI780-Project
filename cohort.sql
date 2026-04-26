CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.readmit_dataset_v3` AS
WITH base AS (
  SELECT
    icu.subject_id,
    icu.hadm_id,
    icu.stay_id,
    icu.intime,
    icu.outtime,
    icu.los             AS icu_los_days,
    icu.first_careunit,
    icu.last_careunit,
    adm.admittime,
    adm.dischtime,
    adm.admission_type,
    adm.discharge_location,
    adm.race,           -- added
    pat.anchor_age      AS age,
    pat.gender
  FROM `physionet-data.mimiciv_3_1_icu.icustays` icu
  JOIN `physionet-data.mimiciv_3_1_hosp.admissions` adm
    ON icu.hadm_id = adm.hadm_id
  JOIN `physionet-data.mimiciv_3_1_hosp.patients` pat
    ON icu.subject_id = pat.subject_id
  WHERE pat.anchor_age >= 18
),


next_adm AS (
  SELECT
    b.subject_id,
    b.hadm_id,
    b.stay_id,
    b.outtime,
    LEAD(b.admittime) OVER (
      PARTITION BY b.subject_id
      ORDER BY b.outtime
    ) AS next_admittime,
    LEAD(b.hadm_id) OVER (
      PARTITION BY b.subject_id
      ORDER BY b.outtime
    ) AS next_hadm
  FROM base b
)


SELECT
  b.subject_id,
  b.hadm_id,
  b.stay_id,
  b.intime,
  b.outtime,
  b.icu_los_days,
  b.first_careunit,
  b.last_careunit,
  b.admittime,
  b.dischtime,
  b.admission_type,
  b.discharge_location,
  b.age,
  b.gender,


  -- race encoding
  CASE
    WHEN b.race LIKE '%WHITE%'                        THEN 'WHITE'
    WHEN b.race LIKE '%BLACK%'                        THEN 'BLACK'
    WHEN b.race LIKE '%ASIAN%'                        THEN 'ASIAN'
    WHEN b.race LIKE '%HISPANIC%'                     THEN 'HISPANIC'
    WHEN b.race IS NULL
      OR b.race LIKE '%UNKNOWN%'
      OR b.race LIKE '%UNABLE%'
      OR b.race LIKE '%DECLINED%'                     THEN 'UNKNOWN'
    ELSE 'OTHER'
  END AS race_group,


  CASE
    WHEN n.next_hadm IS NOT NULL
     AND n.next_hadm != b.hadm_id
     AND TIMESTAMP_DIFF(n.next_admittime, b.outtime, DAY) BETWEEN 0 AND 90
    THEN 1 ELSE 0
  END AS readmit_90


FROM base b
LEFT JOIN next_adm n
  ON b.subject_id = n.subject_id
 AND b.stay_id    = n.stay_id;
