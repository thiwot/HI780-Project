CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.lab_features_last_v3` AS


WITH ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY subject_id, hadm_id, lab_name
      ORDER BY charttime DESC
    ) AS rn
  FROM `hi780-project.mimic_analysis.lab_events_v3`
)
SELECT
  subject_id,
  hadm_id,
  MAX(IF(lab_name='creatinine', valuenum, NULL)) AS last_creatinine,
  MAX(IF(lab_name='bun',        valuenum, NULL)) AS last_bun,
  MAX(IF(lab_name='sodium',     valuenum, NULL)) AS last_sodium,
  MAX(IF(lab_name='potassium',  valuenum, NULL)) AS last_potassium,
  MAX(IF(lab_name='glucose',    valuenum, NULL)) AS last_glucose,
  MAX(IF(lab_name='wbc',        valuenum, NULL)) AS last_wbc,
  MAX(IF(lab_name='hemoglobin', valuenum, NULL)) AS last_hemoglobin,
  MAX(IF(lab_name='platelets',  valuenum, NULL)) AS last_platelets,
  MAX(IF(lab_name='lactate',    valuenum, NULL)) AS last_lactate,
  MAX(IF(lab_name='bilirubin',  valuenum, NULL)) AS last_bilirubin,
  MAX(IF(lab_name='albumin',    valuenum, NULL)) AS last_albumin
FROM ranked
WHERE rn = 1
GROUP BY subject_id, hadm_id;