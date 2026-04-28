CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.diagnosis_v3` AS


SELECT
  a.subject_id,
  a.hadm_id,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '250%')
        OR (icd_version=10 AND icd_code LIKE 'E10%')
        OR (icd_version=10 AND icd_code LIKE 'E11%') THEN 1 ELSE 0 END) AS diabetes,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '428%')
        OR (icd_version=10 AND icd_code LIKE 'I50%') THEN 1 ELSE 0 END) AS chf,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '496%')
        OR (icd_version=10 AND icd_code LIKE 'J44%') THEN 1 ELSE 0 END) AS copd,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '585%')
        OR (icd_version=10 AND icd_code LIKE 'N18%') THEN 1 ELSE 0 END) AS renal_failure,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '401%')
        OR (icd_version=10 AND icd_code LIKE 'I10%') THEN 1 ELSE 0 END) AS hypertension,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '038%')
        OR (icd_version=10 AND icd_code LIKE 'A41%') THEN 1 ELSE 0 END) AS sepsis,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '486%')
        OR (icd_version=10 AND icd_code LIKE 'J18%') THEN 1 ELSE 0 END) AS pneumonia,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '410%')
        OR (icd_version=10 AND icd_code LIKE 'I21%') THEN 1 ELSE 0 END) AS ami,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '434%')
        OR (icd_version=10 AND icd_code LIKE 'I63%') THEN 1 ELSE 0 END) AS stroke,


  MAX(CASE WHEN (icd_version=9  AND icd_code LIKE '571%')
        OR (icd_version=10 AND icd_code LIKE 'K70%')
        OR (icd_version=10 AND icd_code LIKE 'K74%') THEN 1 ELSE 0 END) AS liver_disease,


  MAX(CASE WHEN (icd_version=9  AND icd_code >= '140' AND icd_code < '240')
        OR (icd_version=10 AND icd_code LIKE 'C%') THEN 1 ELSE 0 END) AS cancer


FROM `hi780-project.mimic_analysis.readmit_dataset_v3` a
JOIN `physionet-data.mimiciv_3_1_hosp.diagnoses_icd` d
  ON  a.subject_id = d.subject_id
  AND a.hadm_id    = d.hadm_id
GROUP BY a.subject_id, a.hadm_id;
