CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.icu_stay_count_v3` AS


SELECT
  hadm_id,
  COUNT(DISTINCT stay_id) AS icu_stay_count
FROM `physionet-data.mimiciv_3_1_icu.icustays`
GROUP BY hadm_id;
