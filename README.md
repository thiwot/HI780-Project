# ICU Readmission Prediction - MIMIC-IV
## HI780 Data Mining Course Project
Predicting 90-day unplanned hospital readmission following ICU discharge using structured electronic health record data from the MIMIC-IV v3.1 database.

## Project Overview
This project develops and evaluates machine learning models for predicting 90-day hospital readmission after ICU discharge. Four classification algorithms (Logistic Regression, Naive Bayes, J48 Decision Tree, and Random Forest) were trained and evaluated across full (79-feature) and CFS-selected (4-feature) feature sets using 10-fold stratified cross-validation in both Weka 3.8 and Python 3.x.

A key methodological contribution of this project is the empirical quantification of SMOTE data leakage by comparing results when SMOTE is applied before cross-validation (Weka) versus within training folds only (Python) to demonstrate the performance inflation introduced by incorrect oversampling placement.

## Repository Structure
```
icu-readmission-mimic/
├── README.md
├── synthetic_demo.csv                  # synthetic data for demo (no real patient data)
├── sql/
│   ├── 01_cohort.sql       # base cohort + readmit_90 label
│   ├── 02_prior_admissions.sql      # prior admission count
│   ├── 03_icu_stay.sql        # ICU stay count per hospitalization
│   ├── 04_diagnosis.sql             # 11 ICD comorbidity flags
│   ├── 05_lab_item_map.sql          # lab item mapping
│   ├── 06_lab_events.sql            # raw lab event extraction
│   ├── 07_lab_features_aggregated.sql      # peak lab aggregates
│   ├── 08_lab_features_last.sql     # last lab values (pivoted)
│   ├── 09_vital_signs.sql        # vital sign min/max per stay
│   └── 10_final_table.sql   # final joined feature table
├── python/
│   └── icu_readmission_modeling.ipynb  # full modeling pipeline
└── results/
    ├── roc_curves.png                  # ROC curve figure
```
# Dataset Access
## MIMIC-IV v3.1
This project uses the Medical Information Mart for Intensive Care IV (MIMIC-IV) version 3.1 database, a publicly available collection of deidentified electronic health records from Beth Israel Deaconess Medical Center (BIDMC) in Boston, Massachusetts, covering admissions from 2008 to 2019.

*MIMIC-IV is not included in this repository.* Access must be obtained independently through PhysioNet.

### How to Access MIMIC-IV

**Step 1: Create a PhysioNet account**
- Go to https://physionet.org
- Register using your Gmail account and complete your profile

**Step 2: Complete CITI Training**
- Complete the "Data or Specimens Only Research" CITI training course
   - CITI Course Instructions: https://physionet.org/about/citi-course/
- Upload your certificate to your PhysioNet profile under Settings → CITI Training

**Step 3: Request Access**
- Submit your credentialing application on [https://physionet.org/content/mimiciv/](https://physionet.org/content/mimiciv/3.1/)
- Approval typically takes 1-3 business days

**Step 4: Sign the Data Use Agreement**
- After credentialing request is approve, navigate to [https://physionet.org/content/mimiciv/](https://physionet.org/content/mimiciv/3.1/)
- Read and sign the data use agreement at the bottom of the page

**Step 5: Set Up Google Cloud BigQuery**
- Go to https://console.cloud.google.com
- Sign in with the same Gmail account used for PhysioNet
- Create a new Google Cloud project
- Return to PhysioNet and link your Google account under  Settings → Cloud
- Request access to the BigQuery dataset at: https://physionet.org/content/mimiciv/3.1/

  
**Step 6: Run SQL Pipeline**
- Open Google BigQuery console
- Update the project prefix hi780-project.mimic_analysis 
  in each SQL script to match your own project and dataset name
- Run SQL scripts in order as documented in the SQL Pipeline section
- Export final_model_dataset_v3 as CSV when complete
  
## Running with Synthetic Data
Since MIMIC-IV data cannot be shared publicly, a synthetic dataset is included in this repository for demonstration purposes.
File: synthetic_demo.csv
The synthetic data mirrors the structure and class distribution of the real dataset (91.2% non-readmitted / 8.8% readmitted) but contains no real patient information.

To run the notebook on synthetic data, update the file path in Cell 2: df = pd.read_csv("synthetic_demo.csv")
