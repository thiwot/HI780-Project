CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.lab_item_map_v3` AS


SELECT itemid, lab_name
FROM (
  SELECT
    itemid,
    CASE
      WHEN LOWER(label) LIKE '%creatinine%'                   THEN 'creatinine'
      WHEN LOWER(label) LIKE '%bun%'
        OR LOWER(label) LIKE '%urea nitrogen%'                THEN 'bun'
      WHEN LOWER(label) LIKE '%sodium%'                       THEN 'sodium'
      WHEN LOWER(label) LIKE '%potassium%'                    THEN 'potassium'
      WHEN LOWER(label) LIKE '%glucose%'                      THEN 'glucose'
      WHEN LOWER(label) LIKE '%wbc%'                          THEN 'wbc'
      WHEN LOWER(label) LIKE '%hemoglobin%'                   THEN 'hemoglobin'
      WHEN LOWER(label) LIKE '%platelet%'                     THEN 'platelets'
      WHEN LOWER(label) LIKE '%lactate%'                      THEN 'lactate'
      WHEN LOWER(label) LIKE '%bilirubin%'                    THEN 'bilirubin'
      WHEN LOWER(label) LIKE '%albumin%'                      THEN 'albumin'
    END AS lab_name
  FROM `physionet-data.mimiciv_3_1_hosp.d_labitems`
)
WHERE lab_name IS NOT NULL;