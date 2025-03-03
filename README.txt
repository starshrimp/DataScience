# Data Science

This repo contains the DataScience Submission of Sarah Rebecca Meyer.


## Assignment 1

### Objective
The task is to build a regression model for a peer-to-peer credit marketplace that predicts the appropriate interest rate for loan applicants. The model will be used to assist private lenders in determining a suitable rate based on the applicant’s available information.

### Dataset
The dataset is a modified version of the Lending Club Loan Dataset, which contains anonymized historical loan application data.
Some attributes in the dataset are not available for new applications, so they must be excluded from training.
Data preprocessing involves handling missing values, removing unnecessary attributes, and scaling numerical features.
Tasks

### Business Understanding & Data Exploration

Research financial lending concepts such as credit scores, debt-to-income ratios (DTI), and interest rates.
Explore the dataset to understand feature semantics, distributions, and correlations.
Data Preprocessing

Remove features unavailable in new applications (e.g., loan status, past payments).
Handle missing values and inconsistencies.
Normalize or standardize numerical variables if necessary.
Model Training & Evaluation

Train multiple regression models (e.g., linear regression, decision trees, ensemble methods).
Use Mean Squared Error (MSE) as the primary evaluation metric.
Apply cross-validation to select the best-performing model.
Reality Check & Final Submission

The best model will be tested on a hidden dataset (secret data).
A separate R script must be provided for the final evaluation.
The final model, training dataset, and all experimental scripts must be included in the submission.

Dataset: Modified version of the Lending Club Loan dataset.
Task: Train and validate a regression model to predict loan interest rates.
Evaluation: Models are assessed using Mean Squared Error (MSE) on both public and secret datasets.
Deliverables: A report (PDF) documenting decisions and justifications, along with R code and a "Reality Check" script for final model validation.

- final_main.pdf: This contains our documentation that was created using knitr from our R Markdown file. It couldn't be uploaded to moodle due to size restrictions, which is why it is available at https://fhnw365-my.sharepoint.com/:b:/g/personal/sarah_meyer_students_fhnw_ch/EWMMgX1ezKpEg7GUNqBshikB4U5MYpW325e19r62M66rOg?e=2bAUEA. 
- final_main.Rmd: Our final file where we created the model.
- model_log.txt: In this file, we logged our models upon creation. In this file, you get a glimpse of the work we did and how we progressed / what we changed.
- reality_check.R: The file for the Reality Check. Upon execution, you will be prompted to select the dataset to run it.
- final_model_xgb.rds: Our final XGBoost model with the best performance.

Assignment 2:
- main.pdf: This contains our documentation that was created using knitr from our R Markdown file.
- main.Rmd: Our final file where we created the model.
- all_models_details.txt: In this file, we logged our models upon creation. Here, we only logged promising models, not every model we tried.
- model_outputs: this folder contains the learning curve plots of the models in the model log file. The numbers correspond to the numbers in the log file.
- final_model_plot.png: The learning curve of the final model during training.
- reality_check.R: The file for the Reality Check. Upon execution, you will be prompted to select the dataset to run it.
- normalization_params.csv: This file contains the normalization parameters we obtained from our training dataset and used for the normalization.
- model.keras: Our final Neural Network model with the best performance.
