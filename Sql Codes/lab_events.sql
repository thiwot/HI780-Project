CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.lab_events_v3` AS


SELECT
  le.subject_id,
  r.hadm_id,
  le.charttime,
  le.valuenum,
  m.lab_name
FROM `physionet-data.mimiciv_3_1_hosp.labevents` le
JOIN `hi780-project.mimic_analysis.readmit_dataset_v3` r
  ON  le.subject_id = r.subject_id
  AND le.hadm_id    = r.hadm_id
JOIN `hi780-project.mimic_analysis.lab_item_map_v3` m
  ON  le.itemid = m.itemid
WHERE le.valuenum IS NOT NULL
  AND le.charttime BETWEEN r.intime AND r.outtime;