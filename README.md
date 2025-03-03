# DataScience

This repo contains the Submission for the Data Science Module of the MSc Medical Informatics / Business Information Systems of Sarah Rebecca Meyer.


## Assignment 1: Regression - Interest Rate Prediction

### Objective
The task is to build a regression model for a peer-to-peer credit marketplace that predicts the appropriate interest rate for loan applicants. The model will be used to assist private lenders in determining a suitable rate based on the applicant’s available information.

### Dataset

- The dataset is a modified version of the Lending Club Loan Dataset, which contains anonymized historical loan application data.
- Some attributes in the dataset are not available for new applications, so they must be excluded from training.
- Data preprocessing involves handling missing values, removing unnecessary attributes, and scaling numerical features.

### Tasks

- Business Understanding & Data Exploration
  - Research financial lending concepts such as credit scores, debt-to-income ratios (DTI), and interest rates.
  - Explore the dataset to understand feature semantics, distributions, and correlations.
- Data Preprocessing:
  - Remove features unavailable in new applications (e.g., loan status, past payments).
  - Handle missing values and inconsistencies.
  - Normalize or standardize numerical variables if necessary.
- Model Training & Evaluation:
  - Train multiple regression models (e.g., linear regression, decision trees, ensemble methods).
  - Use Mean Squared Error (MSE) as the primary evaluation metric.
  - Apply cross-validation to select the best-performing model.
- Reality Check & Final Submission
  - The best model will be tested on a hidden dataset (secret data).
  - A separate R script is provided for the final evaluation.
  - The final model, training dataset, and all experimental scripts must be included in the submission.

### Files

- final_main.Rmd: The final file where I performed the data processing and created the model.
- model_log.txt: In this file, I logged models upon creation. In this file, one gets a glimpse of the work I did and how I progressed / what I changed.
- reality_check.R: The file for the Reality Check. Upon execution, you will be prompted to select the dataset to run it.
- final_model_xgb.rds: The final XGBoost model with the best performance.

## Assignment 2: Classification – Credit Card Customer Behavior Prediction

### Objective

This assignment focuses on training a neural network classifier to predict how well a customer will repay their credit card debt based on application data. The goal is to improve risk assessment in credit lending.

### Dataset
- The dataset is a modified version of the Credit Card Approval Dataset, containing anonymized customer applications and their repayment behavior.
- Features include demographics, financial status, and previous credit behavior.
- The target variable represents different delinquency levels (e.g., 30-59 days past due, 90-119 days overdue, etc.).

### Tasks

- Data Exploration & Preprocessing
  - Convert categorical variables into numerical representations.
  - Normalize all input features to be within a [0,1] range, as required for neural networks.
  - Handle missing data and inconsistencies.
-  Model Design & Training
  - Select a feed-forward neural network or another architecture (CNN/RNN) and justify the choice.
  - Experiment with different hyperparameters (e.g., number of layers, activation functions, learning rates).
  - Use 10-fold cross-validation to optimize model performance.
- Evaluation & Reality Check
  - Evaluate model performance using accuracy on both the training and test datasets.
  - The final trained model will be tested on a hidden dataset to assess real-world generalization.
  - The best model and processed datasets must be submitted.

### Files

- main.pdf: This contains the documentation that was created using knitr from the R Markdown file.
- main.Rmd: The final file where the model was created.
- all_models_details.txt: In this file, I logged  models upon creation. Here, only promising models were logged, not every model tried.
- model_outputs: This folder contains the learning curve plots of the models in the model log file. The numbers correspond to the numbers in the log file.
- final_model_plot.png: The learning curve of the final model during training.
- reality_check.R: The file for the Reality Check. Upon execution, you will be prompted to select the dataset to run it.
- normalization_params.csv: This file contains the normalization parameters obtained from our training dataset and used for the normalization.
- model.keras: Our final Neural Network model with the best performance.
