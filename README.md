# HI780-Project: ICU Readmission Prediction - MIMIC-IV
## HI780 Data Mining Course Project
Predicting 90-day unplanned hospital readmission following ICU discharge using structured electronic health record data from the MIMIC-IV v3.1 database.

# Project Overview
This project develops and evaluates machine learning models for predicting 90-day hospital readmission after ICU discharge. Four classification algorithms (Logistic Regression, Naive Bayes, J48 Decision Tree, and Random Forest) were trained and evaluated across full (79-feature) and CFS-selected (4-feature) feature sets using 10-fold stratified cross-validation in both Weka 3.8 and Python 3.x.

A key methodological contribution of this project is the empirical quantification of SMOTE data leakage by comparing results when SMOTE is applied before cross-validation (Weka) versus within training folds only (Python) to demonstrate the performance inflation introduced by incorrect oversampling placement.

# Dataset Access
## MIMIC-IV v3.1
This project uses the Medical Information Mart for Intensive Care IV (MIMIC-IV) version 3.1 database, a publicly available collection of deidentified electronic health records from Beth Israel Deaconess Medical Center (BIDMC) in Boston, Massachusetts.
*MIMIC-IV is not included in this repository.* Access must be obtained independently through PhysioNet.
