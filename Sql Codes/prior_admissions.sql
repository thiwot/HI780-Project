CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.prior_admissions_v3` AS


SELECT
  a.subject_id,
  a.hadm_id,
  COUNT(DISTINCT b.hadm_id) AS prior_admissions
FROM `hi780-project.mimic_analysis.readmit_dataset_v3` a
LEFT JOIN `physionet-data.mimiciv_3_1_hosp.admissions` b
  ON  a.subject_id = b.subject_id
  AND b.dischtime  < a.admittime
GROUP BY a.subject_id, a.hadm_id;
