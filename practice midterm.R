# Load the required packages
library(tidyr)
library(ggplot2)

# Read the provided Global Climate change file
gcc_df <- read.csv("My PC/Analytcal_Methods_of_BUS/R_Assignments/GLB.Ts+dSST.csv", header = TRUE, na.strings = "")

gcc_cols <- c("Year", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# Convert columns with character values to numeric
numeric_cols <- colnames(gcc_df)
gcc_df[numeric_cols] <- sapply(gcc_df[numeric_cols], as.numeric)
# Reshape the data into long format
df_long <- pivot_longer(gcc_df, cols = -Year, names_to = "Month", values_to = "Value")

# Convert "Year" and "Month" columns to appropriate data types
df_long$Year <- as.factor(df_long$Year)
df_long$Month <- factor(df_long$Month, levels = month.abb)
df_long <- df_long[!is.na(df_long$Month), ]

# # Remove non-numeric characters from the "Value" column
# df_long$Value <- as.numeric(gsub("[^0-9.-]", "", df_long$Value))
# df_long <- na.omit(df_long)

# Create the time series plot
ggplot(df_long, aes(x = interaction(Year, Month), y = Value)) +
    geom_line(aes(group = 1)) +
    labs(x = "Year", y = "Temperature Anomaly (°C)") +
    # scale_x_discrete(labels = scales::number_format(accuracy = 1)) +
    scale_y_continuous(labels = scales::number_format(accuracy = 0.1)) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    ggtitle("Global Temperature Anomalies Over Time")
ggplot(df_long, aes(x = Year, y = Value, color = Month)) +
    geom_line() +
    labs(x = "Year", y = "Temperature Anomaly (°C)") +
    scale_x_continuous(breaks = seq(1880, 2019, by = 10)) +
    scale_y_continuous(labels = scales::number_format(accuracy = 0.1)) +
    theme_minimal() +
    ggtitle("Global Temperature Anomalies Over Time (1890-2023)")
# Analyze the plot for trends, seasonality, or cycles
