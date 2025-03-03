if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

if (!require(caret)) {
  install.packages("caret")
  library(caret)
}

if (!require(lubridate)) {
  install.packages("lubridate")
  library(lubridate)
}

if (!require(xgboost)) {
  install.packages("xgboost")
  library(xgboost)
}

if (!require(rstudioapi)) {
  install.packages("rstudioapi")
  library(rstudioapi)
}

if (!require(tidyr)) {
  install.packages("tidyr")
  library(tidyr)
}


setwd(dirname(getActiveDocumentContext()$path))

file_path <- file.choose()
data <- read.csv(file_path, header = TRUE, sep=';')


data_clean <- data %>%
  # Step 1: Exclude the listed columns from assignment information
  dplyr::select(-collection_recovery_fee,
                -installment,
                -funded_amnt,
                -funded_amnt_inv,
                -issue_d,
                -last_pymnt_amnt,
                -last_pymnt_d,
                -loan_status,
                -next_pymnt_d,
                -out_prncp,
                -out_prncp_inv,
                -pymnt_plan,
                -recoveries,
                -total_pymnt,
                -total_pymnt_inv,
                -total_rec_int,
                -total_rec_late_fee,
                -total_rec_prncp) %>% 
  # Step 2: Exclude manually selected columns
  dplyr::select(-policy_code, 
                -title,
                -emp_title,
                -desc,
                -id,
                -member_id,
                -url,
                -zip_code) %>%
  # Step 3: Remove columns with more than 50% NA values
  dplyr::select(where(~ sum(is.na(.)) / nrow(data) <= 0.5))%>%
  # Step 4: Remove rows with more than 40% NA values
  dplyr::filter(rowSums(is.na(.)) / ncol(.) <= 0.4)

# Output the number of columns before and after cleaning for verification
cat("Number of columns before cleaning:", ncol(data), "\n")
cat("Number of columns after cleaning:", ncol(data_clean), "\n")
cat("Number of rows before cleaning:", nrow(data), "\n")
cat("Number of rows after cleaning:", nrow(data_clean), "\n")


data_final <- data_clean %>%
  
  # Label encoding the emp_length variable
  mutate(emp_length_encoded = as.numeric(factor(emp_length, 
                                                levels = c("n/a", "< 1 year", "1 year", "2 years", "3 years", "4 years", 
                                                           "5 years", "6 years", "7 years", "8 years", "9 years", 
                                                           "10+ years"), 
                                                labels = 0:11, ordered = TRUE))) %>%
  
  # Label encoding the loan_term variable
  mutate(term_encoded = as.numeric(factor(trimws(term),  # trimws() removes any extra spaces
                                          levels = c("36 months", "60 months"), 
                                          labels = c(1, 2)))) %>%
  
  mutate(mode_home_ownership = names(sort(table(home_ownership), decreasing = TRUE)[1])) %>%
  # Changing the instances of OTHER, ANY and NONE in the home_ownership column to the mode
  mutate(home_ownership = ifelse(home_ownership %in% c("OTHER", "NONE", "ANY"), 
                                 mode_home_ownership, 
                                 home_ownership)) %>%
  
  # One-Hot Encoding for home_ownership
  {
    dummies <- dummyVars(~ home_ownership, data = .)  # One-hot encoding
    home_ownership_encoded <- data.frame(predict(dummies, newdata = .))
    cbind(., home_ownership_encoded)  # Add the new one-hot encoded columns to the dataset
  } %>%
  
  # Label encoding the verification_status column
  mutate(verification_status_encoded = as.numeric(factor(verification_status, 
                                                         levels = c("Not Verified", "Verified", "Source Verified"), 
                                                         labels = c(0, 1, 2)))) %>%
  
  # One-Hot Encoding for purpose
  {
    dummies_purpose <- dummyVars(~ purpose, data = .)  # One-hot encoding for purpose
    purpose_encoded <- data.frame(predict(dummies_purpose, newdata = .))
    cbind(., purpose_encoded)  # Add the new one-hot encoded columns to the dataset
  } %>%
  
  # One-Hot Encoding for addr_state
  {
    dummies_state <- dummyVars(~ addr_state, data = .)  # One-hot encoding for addr_state
    addr_state_encoded <- data.frame(predict(dummies_state, newdata = .))
    cbind(., addr_state_encoded)  # Add the new one-hot encoded columns to the dataset
  } %>%
  
  # Set dti to NA where dti is 0
  mutate(dti = ifelse(dti == 0, NA, dti)) %>%
  
  # Calculate the modified z-score for the dti column & set dti to NA where the modified z-score is greater than 3.5
  mutate(mod_z_score_dti = 0.6745 * (dti - median(dti, na.rm = TRUE)) / mad(dti, na.rm = TRUE)) %>%
  mutate(dti = ifelse(abs(mod_z_score_dti) > 3.5, NA, dti)) %>%
  
  # Convert earliest_cr_line to a date format
  mutate(earliest_cr_line_date = dmy(paste("01-", earliest_cr_line, sep=""))) %>%
  
  # Convert earliest_cr_line_date to months since January 1, 1950
  mutate(earliest_cr_line_month = as.numeric(difftime(earliest_cr_line_date, 
                                                      as.Date("1950-01-01"), 
                                                      units = "days")) / 30.44) %>%  # 30.44 is average days in a month
  #scale the earliest_cr_line_months
  mutate(earliest_cr_line_scaled = scale(earliest_cr_line_month)) %>%
  
  # Calculate the modified z-score for the revol_bal column & set dti to NA where the modified z-score is greater than 3.5
  mutate(mod_z_score_revol_bal = 0.6745 * (revol_bal - median(revol_bal, na.rm = TRUE)) / mad(revol_bal, na.rm = TRUE)) %>%
  mutate(revol_bal = ifelse(abs(mod_z_score_revol_bal) > 3.5, NA, revol_bal)) %>%
  
  # Calculate the modified z-score for the revol_util column & set dti to NA where the modified z-score is greater than 3.5
  mutate(mod_z_score_revol_util = 0.6745 * (revol_util - median(revol_util, na.rm = TRUE)) / mad(revol_util, na.rm = TRUE)) %>%
  mutate(revol_util = ifelse(abs(mod_z_score_revol_util) > 3.5, NA, revol_util)) %>%
  
  # Label Encoding for initial_list_status
  mutate(initial_list_status_encoded = as.numeric(factor(initial_list_status,  
                                                         levels = c("f", "w"), 
                                                         labels = c(1, 2))))  %>%
  
  
  # Convert last_credit_pull to a date format
  mutate(last_credit_pull_date = dmy(paste("01-", last_credit_pull_d, sep=""))) %>%
  
  # Convert earliest_cr_line_date to months since January 1, 1950
  mutate(last_credit_pull_month = as.numeric(difftime(last_credit_pull_date, 
                                                      as.Date("1950-01-01"), 
                                                      units = "days")) / 30.44) %>%  # 30.44 is average days in a month
  #scale the earliest_cr_line_months
  mutate(last_credit_pull_scaled = scale(last_credit_pull_month)) %>%
  
  
  mutate(application_type_encoded = as.numeric(factor(application_type,  
                                                      levels = c("INDIVIDUAL", "JOINT"), 
                                                      labels = c(1, 2))))  %>%
  

  # Replace empty strings and NA with 'Not Applicable' in verification_status_joint
  mutate(verification_status_joint = if_else(
    "verification_status_joint" %in% names(.) & !is.na(verification_status_joint),
    verification_status_joint,
    "Not Applicable")) %>%
  
  # Ordinal encoding for verification_status_joint (keeping 'Not Applicable' as separate)
  mutate(verification_status_joint_encoded = case_when(
    verification_status_joint == 'Not Applicable' ~ -1,  # Not Applicable
    verification_status_joint == 'Not Verified' ~ 0,
    verification_status_joint == 'Verified' ~ 1,
    verification_status_joint == 'Source Verified' ~ 2
  )) %>%
  
  # Log-Transformation & Capping: Step 1: Capping tot_coll_amt at the 99th percentile
  {
    cap_value <- quantile(.$tot_coll_amt, 0.99, na.rm = TRUE)  # Calculate 99th percentile cap
    mutate(., tot_coll_amt_capped = ifelse(tot_coll_amt > cap_value, cap_value, tot_coll_amt))
  } %>%
  
  # Log-Transformation & Capping: Step 2: Apply log transformation to the capped values of tot_coll_amt
  mutate(tot_coll_amt_log_capped = log1p(tot_coll_amt_capped))  %>%# Apply log1p to capped values
  
  # Set total_rev_hi_lim to NA where its value is 9999999
  mutate(total_rev_hi_lim = ifelse(total_rev_hi_lim == 9999999, NA, total_rev_hi_lim)) %>%
  
  select(-emp_length,
         -term,
         -home_ownership,
         -verification_status,
         -addr_state,
         -purpose,
         -mod_z_score_dti,
         -earliest_cr_line,
         -earliest_cr_line_date,
         -earliest_cr_line_month,
         -mod_z_score_revol_bal,
         -mod_z_score_revol_util,
         -initial_list_status,
         -last_credit_pull_d,
         -last_credit_pull_date,
         -last_credit_pull_month,
         -application_type,
         -verification_status_joint,
         -tot_coll_amt,
         -tot_coll_amt_capped,
         -mode_home_ownership)


# here we load the model
best_model <- readRDS("final_model_xgb.rds")

feature_names <- best_model$feature_names

missing_features <- setdiff(feature_names, colnames(data_final))

# Add missing features with zeros
for (feature in missing_features) {
  data_final[[feature]] <- 0
}

data_final <- data_final[, sort(colnames(data_final))]


# Application of the model
x <- data_final[, -which(names(data_final) == "int_rate")]
y <- data_final$int_rate

x <- x[, sort(colnames(x)), drop = FALSE]

predicted <- predict(best_model, as.matrix(x))

# MSE for the new data evaluation
print((mean((predicted - y)^2)))
