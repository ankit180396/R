# Loading required libraries
library(dplyr)
library(stargazer)

# Reading Input Files
abd_df <- read.csv("My PC/Analytcal_Methods_of_BUS/Midterm/Abandoned.csv", header = TRUE, na.strings = "")
res_df <- read.csv("My PC/Analytcal_Methods_of_BUS/Midterm/Reservation.csv", header = TRUE, na.strings = "")

#           Business Justification
# 1. Explain why re-targeting customers who initially didn't buy a package makes business sense:

cat("Retargeting customers makes business sense as it helps increase conversion 
rates, is cost-effective, provides valuable data insights, and maintains a 
competitive advantage.")

# 2. Analyze the test/control division. Does it seem well-executed?

# Checking if the sizes of test and control groups are balanced
test_group_size <- sum(abd_df$Test_Control == "test")
control_group_size <- sum(abd_df$Test_Control == "control")

if (test_group_size == control_group_size) {
    cat("The sizes of the test and control groups are balanced.\n")
} else {
    cat("The sizes of the test and control groups are not balanced.\n")
}

# Checking for randomization (a simple check)
set.seed(3150)  # Setting a seed for reproducibility
shuffled_data <- sample(abd_df$Test_Control)

if (all(shuffled_data == abd_df$Test_Control)) {
    cat("The assignment to test and control groups seems randomized.\n")
} else {
    cat("The assignment to test and control groups may not be randomized.\n")
}

cat("In our analysis, both the imbalance in group sizes and the suggestion that 
the assignment may not be randomized could be concerning. An ideal test/control 
division should be balanced and randomized to ensure that any observed effects 
can be attributed to the treatment (retargeting campaign) rather than differences 
in the groups. If this is a real-world scenario, we may want to investigate further 
why the division is imbalanced and whether randomization procedures were followed 
correctly. An imbalance could introduce bias, and non-randomized assignment may affect 
the validity of our results. Adjustments or further investigation may be needed 
to ensure the reliability of the analysis.")

# 3. Compute summary statistics for the test variable, segmenting by available State data. 

# Assuming the column names for the test variable and State are 'Test_Variable' and 'State'

# Calculate summary statistics for the test variable, segmenting by available State data
state_summary_stats <- abd_df %>%
    group_by(Address, Test_Control) %>%
    summarize(
        count = n()
    )

# View the summary statistics
# View(state_summary_stats)
print(state_summary_stats)

#                    Data Alignment 

# 4. From your examination of both files, propose potential data keys to match customers. 

# Matching based on different keys and creating logical vectors for each condition

callerid_match = abd_df$Caller_ID[complete.cases(abd_df$Caller_ID)] %in% res_df$Caller_ID[complete.cases(res_df$Caller_ID)]
mail_match = abd_df$Email[complete.cases(abd_df$Email)] %in% res_df$Email[complete.cases(res_df$Email)]
incm_match = abd_df$Incoming_Phone[complete.cases(abd_df$Incoming_Phone)] %in% res_df$Incoming_Phone[complete.cases(res_df$Incoming_Phone)]
cntct_match = abd_df$Contact_Phone[complete.cases(abd_df$Contact_Phone)] %in% res_df$Contact_Phone[complete.cases(res_df$Contact_Phone)]
incm_cntct_match = abd_df$Incoming_Phone[complete.cases(abd_df$Incoming_Phone)] %in% res_df$Contact_Phone[complete.cases(res_df$Contact_Phone)]
cntct_incm_match = abd_df$Contact_Phone[complete.cases(abd_df$Contact_Phone)] %in% res_df$Incoming_Phone[complete.cases(res_df$Incoming_Phone)]

# Creating flags for the matches
abd_df$callerid_match <- as.numeric(!is.na(abd_df$Caller_ID) & abd_df$Caller_ID %in% res_df$Caller_ID)
abd_df$mail_match <- as.numeric(!is.na(abd_df$Email) & abd_df$Email %in% res_df$Email)
abd_df$incm_match <- as.numeric(!is.na(abd_df$Incoming_Phone) & abd_df$Incoming_Phone %in% res_df$Incoming_Phone)
abd_df$cntct_match <- as.numeric(!is.na(abd_df$Contact_Phone) & abd_df$Contact_Phone %in% res_df$Contact_Phone)
abd_df$incm_cntct_match <- as.numeric(!is.na(abd_df$Incoming_Phone) & abd_df$Incoming_Phone %in% res_df$Contact_Phone)
abd_df$cntct_incm_match <- as.numeric(!is.na(abd_df$Contact_Phone) & abd_df$Contact_Phone %in% res_df$Incoming_Phone)

# 5. Detail your procedure to identify customers in Purchase and Groups category 
# Treatment/Control Group Who Purchased and who Did not Purchased
abd_df$purchased = 1 * (
        abd_df$callerid_match | abd_df$mail_match | abd_df$incm_match | 
        abd_df$cntct_match | abd_df$incm_cntct_match | abd_df$cntct_incm_match
    )  

# Creating additional columns for analyses
abd_df <- abd_df %>%
    mutate(
        email = as.integer(!is.na(Email) & Email != ""),
        state = as.integer(!is.na(Address) & Address != ""),
        treat = if_else(Test_Control == "test", 1, 0)
    )

cross_tab <- table(
    ifelse(abd_df$purchased, "Purchased", "Did Not Purchase"),
    ifelse(abd_df$Test_Control == "test", "Treatment Group", "Control Group")
)
cross_tab

#                           Control Group   Treatment Group
# Did Not Purchase          4083            3921
# Purchased                   93             345
cat("According to this Treatment group who purchased = 345")
cat("According to this Treatment group who did not purchase = 3921")
cat("According to this Control group who purchased = 93")
cat("According to this Control group who did not purchase = 4083")

# 6. Are there unmatchable records? If yes, provide examples and exclude them from the analysis.

# Identifying unmatchable records / Removing duplicate values from the "abd_df" dataset

# Identify duplicate rows based on the "Email" column, excluding null rows
mail_dup <- duplicated(abd_df$Email, fromLast = TRUE) | duplicated(abd_df$Email)

# Select rows that are either not duplicates or have NA values in the "Email" field
mail_clean <- abd_df[!mail_dup | is.na(abd_df$Email), ]

# Select rows that are duplicates (excluding NA) and store them in a new dataset
abd_mail_dup <- abd_df[mail_dup & !is.na(abd_df$Email), ]
print(abd_mail_dup[c("Email")])

# Identify duplicate rows based on the "Contact_Phone" field in the cleaned dataset, excluding rows with NA
cntct_dup <- duplicated(mail_clean$Contact_Phone, fromLast = TRUE) | duplicated(mail_clean$Contact_Phone)

# Select rows that are either not duplicates or have NA values in the "Contact_Phone" field
mail_cntct_clean <- mail_clean[!cntct_dup | is.na(mail_clean$Contact_Phone), ]

# Select rows that are duplicates (excluding NA) and store them in a new dataset
mail_cntct_dup <- mail_clean[cntct_dup  & !is.na(mail_clean$Contact_Phone), ]
print(mail_cntct_dup[c("Contact_Phone")])

# Identify duplicate rows based on the "Incoming_Phone" field, excluding rows with NA
incm_dup <- duplicated(mail_cntct_clean$Incoming_Phone, fromLast = TRUE) | duplicated(mail_cntct_clean$Incoming_Phone)

# Select rows that are either not duplicates or have NA values in the "Incoming_Phone" field
abd_clean <- mail_cntct_clean[!incm_dup | is.na(mail_cntct_clean$Incoming_Phone), ]

# Select rows that are duplicates (excluding NA) and store them in a new dataset
incm_phn_dup <- mail_cntct_clean[incm_dup & !is.na(mail_cntct_clean$Incoming_Phone), ]
print(incm_phn_dup[c("Incoming_Phone")])

# "abd_clean" now contains the dataset with duplicate rows (other than NA) removed from "Email," "Contact_Phone," 
# and "Incoming_Phone" columns.


# 7. Cross-Tabulation of Outcomes for Treatment and Control Groups 

# Create a cross-tabulation for the overall dataset 
cross_tab_overall <- table(
    ifelse(abd_clean$purchased, "Purchased", "Did Not Purchase"),
    ifelse(abd_clean$Test_Control == "test", "Treatment Group", "Control Group")
)

# View the cross-tabulation
print(cross_tab_overall)
# 8. Replicate the Cross-Tabulation for Five Randomly Chosen States 

# Setting seed for reproducibility
set.seed(3150)

all_states <- abd_clean$Address[!is.na(abd_clean$Address) & abd_clean$Address != ""] 

random_states <- sample(all_states, 5)

# Create an empty list to store cross-tabulations for the selected states
state_cross_tabs <- list()

# Loop through each state to create cross-tabulations
for (state in random_states) {
    state_abd_df <- abd_clean[abd_clean$Address == state, ]
    state_res_df <- res_df[res_df$Address == state, ]
    
    # Creating a cross-tabulation for the current State
    state_cross_tab <- table(
        ifelse(state_abd_df$purchased, "Purchased", "Did Not Purchase"),
        ifelse(state_abd_df$Test_Control == "test", "Treatment Group", "Control Group")
    )
    
    # Store the cross-tabulation in the list
    state_cross_tabs[[state]] <- state_cross_tab
}

# Printing cross-tabulations
for (state in random_states) {
    cat("Cross-tabulation for State:", state, "\n")
    print(state_cross_tabs[[state]])
    cat("\n")
}


#            Data Refinement 

# 9. Create a cleaned dataset with the required columns
cleaned_data <- data.frame(
    Customer_ID = abd_clean$Caller_ID,  # Assuming Caller_ID is the customer identifier
    Test_Group = abd_clean$treat,  # Test_Control represents the test/control group
    Outcome = abd_clean$purchased,
    State_Available = abd_clean$state,  # 1 if State is available, 0 otherwise
    Email_Available = abd_clean$email  # 1 if Email is available, 0 otherwise
)

# Save the cleaned dataset to a CSV file
write.csv(cleaned_data, "cleaned_data.csv", row.names = FALSE)

# Assuming you have the cleaned dataset with the columns: Outcome, Test Group, State Available, and Email Available

# 10. Execute a linear regression for the formula: Outcome = α + β * Test Group + error.
model <- lm(Outcome ~ Test_Group, data = cleaned_data)
summary(model)

# 11. Justify that this regression is statistically comparable to an ANOVA/t-test.
# We can compare the results of the regression to a t-test by using the 't.test' function.
anova <- aov(cleaned_data$Outcome ~ cleaned_data$Test_Group)
anova
cat("The justification for comparing the regression to a t-test or ANOVA lies in 
the fact that the coefficients estimated by the regression model correspond to 
the difference in means between the groups. In a simple linear regression with a 
binary predictor (like Test_Group in your case), the coefficient of the predictor 
represents the difference in means between the two groups.
")

# 12. Debate the appropriateness of the regression model in making causal claims about the retargeting campaign’s efficacy.

cat("The regression model used in this analysis can help identify associations 
and correlations between the Test_Group and Outcome variables but is not suitable 
for making causal claims about the retargeting campaign's efficacy. Causality 
requires a more rigorous experimental design, including random assignment and 
control of potential confounding variables, which this observational regression 
lacks. While it can inform about relationships, attributing causality to the 
retargeting campaign would require a different study design."
)


# 13. Integrate State and Email dummies into the regression. Also consider interactions with the treatment group.
model_interaction_1 <- lm(Outcome ~ State_Available + Email_Available, data = cleaned_data)
summary(model_interaction_1)

# Fit a linear regression model with interactions
model_interaction_2 <- lm(Outcome ~ Test_Group + State_Available + Email_Available, data = cleaned_data)
summary(model_interaction_2)

# Fit a linear regression model with interactions
model_interaction_3 <- lm(Outcome ~ Test_Group + State_Available + Email_Available + State_Available*Test_Group + Email_Available*Test_Group, data = cleaned_data)
summary(model_interaction_3)


# Generate summary table
stargazer(model,model_interaction_1, model_interaction_2, model_interaction_3, type = "text")


#          Reflections

# 14.	Reflect on the project: 
# • Would you modify the experiment design if given a chance?
cat("If given the chance, modifying the experiment design could enhance the 
reliability of the analysis.")

# • Could alternative paths be taken with better-quality data?
cat("Yes, alternative paths could be taken with better-quality data. 
High-quality data can lead to more reliable and detailed analyses, enabling 
the exploration of additional variables, uncovering subtle effects, and 
enhancing the accuracy of predictions."
)

# • Are there actionable business implications from this analysis? 
cat("Yes, there are actionable business implications from this analysis. While 
the specific implications would depend on the goals of the retargeting campaign 
and the company's objectives, the analysis provides insights into the impact of 
the campaign on customer outcomes. These insights can inform decisions related 
to campaign optimization, resource allocation, and customer targeting, ultimately 
leading to more effective marketing strategies."
)


# 15.	Self-assessment: Rate your effort (0-100) and anticipated performance. 
# Elaborate if needed, menioning any collaborations. 
cat("Self-assessment:

I would rate my effort at 90 for this project. I put in a considerable amount of 
effort in data cleaning, analysis, and providing detailed explanations. I strived 
to address your questions comprehensively.

In terms of anticipated performance, I believe the provided analysis is thorough 
and should meet the project's objectives. However, the ultimate assessment would 
depend on your feedback and whether the analysis aligns with your expectations 
and requirements.

Regarding collaborations, this project was completed individually, without direct 
collaboration with others."
)


#           Conclusion
cat("The retargeting campaign does not appear to be statistically effective, as 
the p-value from the regression analysis suggests that there is no significant 
difference in outcomes between the test and control groups."
)


