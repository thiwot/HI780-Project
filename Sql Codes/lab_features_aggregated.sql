CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.lab_features_agg_v3` AS


SELECT
  subject_id,
  hadm_id,
  MAX(IF(lab_name='creatinine', valuenum, NULL)) AS max_creatinine,
  MAX(IF(lab_name='bun',        valuenum, NULL)) AS max_bun,
  MIN(IF(lab_name='sodium',     valuenum, NULL)) AS min_sodium,
  MAX(IF(lab_name='sodium',     valuenum, NULL)) AS max_sodium,
  MAX(IF(lab_name='potassium',  valuenum, NULL)) AS max_potassium,
  MAX(IF(lab_name='glucose',    valuenum, NULL)) AS max_glucose,
  MAX(IF(lab_name='wbc',        valuenum, NULL)) AS max_wbc,
  MIN(IF(lab_name='hemoglobin', valuenum, NULL)) AS min_hemoglobin,
  MIN(IF(lab_name='platelets',  valuenum, NULL)) AS min_platelets,
  MAX(IF(lab_name='lactate',    valuenum, NULL)) AS max_lactate,
  MAX(IF(lab_name='bilirubin',  valuenum, NULL)) AS max_bilirubin,
  MIN(IF(lab_name='albumin',    valuenum, NULL)) AS min_albumin
FROM `hi780-project.mimic_analysis.lab_events_v3`
GROUP BY subject_id, hadm_id;