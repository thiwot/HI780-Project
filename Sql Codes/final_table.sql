CREATE OR REPLACE TABLE `hi780-project.mimic_analysis.final_model_dataset_v3` AS
SELECT
  -- identifiers
  r.subject_id,
  r.hadm_id,
  -- demographics
  r.age,
  CASE WHEN r.gender = 'M' THEN 1 ELSE 0 END AS gender_male,
  -- race dummies (reference category: WHITE)
  CASE WHEN r.race_group = 'BLACK'    THEN 1 ELSE 0 END AS race_black,
  CASE WHEN r.race_group = 'ASIAN'    THEN 1 ELSE 0 END AS race_asian,
  CASE WHEN r.race_group = 'HISPANIC' THEN 1 ELSE 0 END AS race_hispanic,
  CASE WHEN r.race_group = 'OTHER'    THEN 1 ELSE 0 END AS race_other,
  CASE WHEN r.race_group = 'UNKNOWN'  THEN 1 ELSE 0 END AS race_unknown,
  -- admission context
  CASE WHEN r.admission_type IN (
    'EW EMER.', 'DIRECT EMER.', 'URGENT',
    'AMBULATORY OBSERVATION', 'DIRECT OBSERVATION',
    'EU OBSERVATION', 'OBSERVATION ADMIT'
  ) THEN 1 ELSE 0 END AS admission_emergency,

  CASE WHEN r.discharge_location IN (
    'HOME', 'HOME HEALTH CARE'
  ) THEN 1 ELSE 0 END AS discharge_to_home,

  CASE WHEN r.discharge_location IN (
    'SNF', 'REHAB/DISTINCT PART HOSP',
    'LONG TERM CARE HOSPITAL', 'SHORT TERM HOSPITAL',
    'CHRONIC/LONG TERM ACUTE CARE'
  ) THEN 1 ELSE 0 END AS discharge_to_skilled_care,

 CASE WHEN r.discharge_location IN (
    'HOSPICE-HOME', 'HOSPICE-MEDICAL FACILITY'
  ) THEN 1 ELSE 0 END AS discharge_to_hospice,

  -- first care unit dummies (reference: MICU)
  CASE WHEN r.first_careunit = 'Surgical Intensive Care Unit (SICU)'
       THEN 1 ELSE 0 END AS first_unit_sicu,
  CASE WHEN r.first_careunit = 'Medical/Surgical Intensive Care Unit (MICU/SICU)'
       THEN 1 ELSE 0 END AS first_unit_micu_sicu,
  CASE WHEN r.first_careunit = 'Trauma SICU (TSICU)'
       THEN 1 ELSE 0 END AS first_unit_tsicu,
  CASE WHEN r.first_careunit = 'Cardiac Vascular Intensive Care Unit (CVICU)'
       THEN 1 ELSE 0 END AS first_unit_cvicu,
  CASE WHEN r.first_careunit = 'Coronary Care Unit (CCU)'
       THEN 1 ELSE 0 END AS first_unit_ccu,
  CASE WHEN r.first_careunit = 'Neuro Surgical Intensive Care Unit (Neuro SICU)'
       THEN 1 ELSE 0 END AS first_unit_neurosicu,
  CASE WHEN r.first_careunit = 'Neuro Intermediate'
       THEN 1 ELSE 0 END AS first_unit_neuro_int,
  CASE WHEN r.first_careunit = 'Neuro Stepdown'
       THEN 1 ELSE 0 END AS first_unit_neuro_step,
  CASE WHEN r.first_careunit IN (
    'PACU', 'Intensive Care Unit (ICU)', 'Medicine',
    'Surgery/Trauma', 'Surgery/Vascular/Intermediate',
    'Medicine/Cardiology Intermediate', 'Neurology', 'Med/Surg'
  ) THEN 1 ELSE 0 END AS first_unit_other,

  -- last care unit dummies (reference: MICU)
  CASE WHEN r.last_careunit = 'Surgical Intensive Care Unit (SICU)'
       THEN 1 ELSE 0 END AS last_unit_sicu,
  CASE WHEN r.last_careunit = 'Medical/Surgical Intensive Care Unit (MICU/SICU)'
       THEN 1 ELSE 0 END AS last_unit_micu_sicu,
  CASE WHEN r.last_careunit = 'Trauma SICU (TSICU)'
       THEN 1 ELSE 0 END AS last_unit_tsicu,
  CASE WHEN r.last_careunit = 'Cardiac Vascular Intensive Care Unit (CVICU)'
       THEN 1 ELSE 0 END AS last_unit_cvicu,
  CASE WHEN r.last_careunit = 'Coronary Care Unit (CCU)'
       THEN 1 ELSE 0 END AS last_unit_ccu,
  CASE WHEN r.last_careunit = 'Neuro Surgical Intensive Care Unit (Neuro SICU)'
       THEN 1 ELSE 0 END AS last_unit_neurosicu,
  CASE WHEN r.last_careunit = 'Neuro Intermediate'
       THEN 1 ELSE 0 END AS last_unit_neuro_int,
  CASE WHEN r.last_careunit = 'Neuro Stepdown'
       THEN 1 ELSE 0 END AS last_unit_neuro_step,
  CASE WHEN r.last_careunit IN (
    'PACU', 'Intensive Care Unit (ICU)', 'Medicine',
    'Surgery/Trauma', 'Surgery/Vascular/Intermediate',
    'Medicine/Cardiology Intermediate', 'Neurology', 'Med/Surg'
  ) THEN 1 ELSE 0 END AS last_unit_other,

  -- utilization
  r.icu_los_days,
  p.prior_admissions,
  c.icu_stay_count,
  -- comorbidities
  d.diabetes,
  d.chf,
  d.copd,
  d.renal_failure,
  d.hypertension,
  d.sepsis,
  d.pneumonia,
  d.ami,
  d.stroke,
  d.liver_disease,
  d.cancer,

  -- lab extremes
  la.max_creatinine,
  la.max_bun,
  la.min_sodium,
  la.max_sodium,
  la.max_potassium,
  la.max_glucose,
  la.max_wbc,
  la.min_hemoglobin,
  la.min_platelets,
  la.max_lactate,
  la.max_bilirubin,
  -- lab discharge values
  ll.last_creatinine,
  ll.last_bun,
  ll.last_sodium,
  ll.last_potassium,
  ll.last_glucose,
  ll.last_wbc,
  ll.last_hemoglobin,
  ll.last_platelets,
  ll.last_lactate,
  ll.last_bilirubin,
  -- vital extremes
  v.min_hr,
  v.max_hr,
  v.min_sbp,
  v.max_sbp,
  v.min_map,
  v.min_rr,
  v.max_rr,
  v.min_spo2,
  v.min_temp_c,
  v.max_temp_c,

  -- missingness indicators
  CASE WHEN la.max_lactate    IS NULL THEN 1 ELSE 0 END AS lactate_missing,
  CASE WHEN la.max_creatinine IS NULL THEN 1 ELSE 0 END AS creatinine_missing,
  CASE WHEN la.max_bun        IS NULL THEN 1 ELSE 0 END AS bun_missing,
  CASE WHEN v.min_sbp         IS NULL THEN 1 ELSE 0 END AS sbp_missing,
  CASE WHEN la.min_albumin    IS NULL THEN 1 ELSE 0 END AS albumin_missing,

  -- target
  r.readmit_90


FROM `hi780-project.mimic_analysis.readmit_dataset_v3` r
LEFT JOIN `hi780-project.mimic_analysis.prior_admissions_v3` p
  ON p.subject_id = r.subject_id
  AND p.hadm_id   = r.hadm_id
LEFT JOIN `hi780-project.mimic_analysis.icu_stay_count_v3` c
  ON c.hadm_id = r.hadm_id
LEFT JOIN `hi780-project.mimic_analysis.diagnosis_v3` d
  ON d.subject_id = r.subject_id
  AND d.hadm_id   = r.hadm_id
LEFT JOIN `hi780-project.mimic_analysis.lab_features_agg_v3` la
  ON la.subject_id = r.subject_id
  AND la.hadm_id   = r.hadm_id
LEFT JOIN `hi780-project.mimic_analysis.lab_features_last_v3` ll
  ON ll.subject_id = r.subject_id
  AND ll.hadm_id   = r.hadm_id
LEFT JOIN `hi780-project.mimic_analysis.vital_features_v3` v
  ON v.subject_id = r.subject_id
  AND v.hadm_id   = r.hadm_id;
