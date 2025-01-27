# Advertising Campaign Analysis - QMB 6304 Midterm Project

## Overview

This repository contains the analysis for the **Advertising Campaign** of a prominent travel agency. The primary objective of the project is to determine the statistical success of a retargeting campaign aimed at customers who initially showed interest in purchasing vacation packages but did not make a purchase.

The project utilizes two datasets: 

- **Abandoned.csv (ABD)**: Data on customers who engaged but didn’t purchase a vacation package.
- **Reservation.csv (RES)**: Data on customers who eventually made a purchase.

### Objective

To assess the effectiveness of a retargeting campaign by matching and analyzing the two datasets (ABD and RES). We aim to evaluate if the retargeting campaign has had a statistically significant impact on the conversion rate of customers who were retargeted.

---

## Contents

- **Analysis Files**:
  - `analysis.R`: Contains the R code for data cleaning, statistical analysis, and regression models.
  - `cleaned_data.csv`: The cleaned and refined dataset used in the analysis.
- **Project Report**: 
  - Explanation of business justification, statistical analysis, and reflections on the experiment.

---

## Analysis Steps

### 1. **Business Justification**
   - **Why Retargeting?**  
     Retargeting customers who did not initially buy a package is a cost-effective strategy that increases conversion rates, provides valuable data insights, and maintains a competitive edge.

   - **Test/Control Division**  
     - The test group has 4266 customers, and the control group has 4176. The division is not perfectly balanced, and there may be concerns regarding randomization. This imbalance could introduce bias into the results.
   
   - **Test Group Summary**  
     Summary statistics for the test group segmented by state are computed to understand regional differences.

### 2. **Data Alignment & Matching**
   - **Matching Customers**:  
     Potential keys for matching customers across the datasets include `Email`, `Incoming_Phone`, and `Contact_Phone`.

   - **Cross-Tabulation of Outcomes**:  
     The following outcomes are determined:
     - **Treatment Group who Purchased**: 345
     - **Treatment Group who Didn’t Purchase**: 3921
     - **Control Group who Purchased**: 93
     - **Control Group who Didn’t Purchase**: 4083

   - **Unmatchable Records**:  
     Some records were found to have duplicate entries based on the matching keys. These duplicates were cleaned and excluded from the final analysis.

   - **State-Level Analysis**:  
     A cross-tabulation of outcomes for five randomly chosen states is provided in the R file for further insights.

### 3. **Data Refinement**
   - **Cleaned Dataset**:  
     The final cleaned dataset contains the following columns:
     - `Customer_ID`
     - `Test_Group`
     - `Outcome`
     - `State_Available`
     - `Email_Available`

     This dataset is attached as `cleaned_data.csv`.

### 4. **Statistical Assessment**
   - **Linear Regression**:  
     A linear regression model was executed to determine the effect of the test group on the outcome. The formula used is:
     ```R
     Outcome = α + β * Test_Group + error
     ```
     The results showed a statistically significant difference between the test and control groups.

   - **ANOVA Comparison**:  
     The results of the linear regression were compared to an ANOVA. Both methods yielded similar conclusions, supporting the analysis that the test group has a significant impact on the outcome.

   - **Causal Inferences**:  
     The regression model helps in identifying correlations but cannot establish causal relationships due to the lack of random assignment and control for confounding variables.

   - **Additional Regression Models**:  
     Models incorporating `State_Available`, `Email_Available`, and their interactions with the test group were evaluated. The test group and some interaction terms were found to be significant predictors of the outcome.

### 5. **Reflections**
   - **Experiment Design**:  
     If given the chance, the experiment design would be modified to ensure better randomization and balanced groups, which could improve the reliability of the results.

   - **Better-Quality Data**:  
     With higher quality data, the analysis could be extended to include more complex models or consider additional variables that may better explain customer behavior.

   - **Actionable Business Implications**:  
     Insights from the analysis can inform decisions regarding campaign optimization, resource allocation, and more targeted marketing strategies.

### 6. **Self-Assessment**
   - **Effort Rating**: 90/100  
     The project was completed with substantial effort in data cleaning, statistical analysis, and detailed reporting.

   - **Anticipated Performance**:  
     The analysis is thorough and aligns with the project's objectives, though the final assessment will depend on the feedback received.

---

## Files

- `analysis.R`: Contains the R code used for the analysis.
- `cleaned_data.csv`: The cleaned dataset after data alignment and refinement.

---

## Running the Analysis

To reproduce the analysis, follow these steps:

1. Install required libraries (if not already installed):

   ```R
   install.packages(c("dplyr", "ggplot2", "stargazer", "tidyr"))
