CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.vital_features_v3` AS


WITH
cohort_stays AS (
  SELECT DISTINCT stay_id, subject_id, hadm_id, intime, outtime
  FROM `hi780-project.mimic_analysis.readmit_dataset_v3`
),


vitals_filtered AS (
  SELECT
    ce.stay_id,
    ce.charttime,
    ce.itemid,
    ce.valuenum
  FROM `physionet-data.mimiciv_3_1_icu.chartevents` ce
  WHERE ce.itemid IN (
    220045,
    220050, 220179,
    220051, 220180,
    220052, 220181, 225312,
    220210, 224690,
    220277,
    223762, 223761
  )
  AND ce.valuenum IS NOT NULL
  AND ce.stay_id IN (SELECT stay_id FROM cohort_stays)
),


vitals_raw AS (
  SELECT
    cs.subject_id,
    cs.hadm_id,


    CASE WHEN v.itemid = 220045
          AND v.valuenum > 0 AND v.valuenum < 300
         THEN v.valuenum END AS heart_rate,


    CASE WHEN v.itemid IN (220050, 220179)
          AND v.valuenum > 0 AND v.valuenum < 400
         THEN v.valuenum END AS sbp,


    CASE WHEN v.itemid IN (220051, 220180)
          AND v.valuenum > 0 AND v.valuenum < 300
         THEN v.valuenum END AS dbp,


    CASE WHEN v.itemid IN (220052, 220181, 225312)
          AND v.valuenum > 0 AND v.valuenum < 300
         THEN v.valuenum END AS map,


    CASE WHEN v.itemid IN (220210, 224690)
          AND v.valuenum > 0 AND v.valuenum < 70
         THEN v.valuenum END AS resp_rate,


    CASE WHEN v.itemid = 220277
          AND v.valuenum > 0 AND v.valuenum <= 100
         THEN v.valuenum END AS spo2,


    CASE
      WHEN v.itemid = 223762
       AND v.valuenum BETWEEN 25 AND 46
      THEN v.valuenum
      WHEN v.itemid = 223761
       AND v.valuenum BETWEEN 70 AND 120
       AND ROUND((v.valuenum - 32) * 5.0 / 9.0, 2) BETWEEN 25 AND 46
      THEN ROUND((v.valuenum - 32) * 5.0 / 9.0, 2)
    END AS temp_c


  FROM vitals_filtered v
  JOIN cohort_stays cs
    ON v.stay_id = cs.stay_id
  WHERE v.charttime BETWEEN cs.intime AND cs.outtime
)


SELECT
  subject_id,
  hadm_id,
  MIN(heart_rate) AS min_hr,
  MAX(heart_rate) AS max_hr,
  MIN(sbp)        AS min_sbp,
  MAX(sbp)        AS max_sbp,
  MIN(map)        AS min_map,
  MIN(resp_rate)  AS min_rr,
  MAX(resp_rate)  AS max_rr,
  MIN(spo2)       AS min_spo2,
  MIN(temp_c)     AS min_temp_c,
  MAX(temp_c)     AS max_temp_c
FROM vitals_raw
GROUP BY subject_id, hadm_id;