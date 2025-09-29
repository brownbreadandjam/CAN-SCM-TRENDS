



getwd()
setwd("C:/Users/naved/Downloads")

# Load required library
library(dplyr)

# Import the CSV file
data <- read.csv("GovDS2 - SCM Baseline.csv", stringsAsFactors = FALSE)

# Clean the data
cleaned_data <- data %>%
  # Remove rows where Location is "Canada"
  filter(Location != "Canada") %>%
  # Remove Vector Coordinate and UOM columns
  select(-Vector, -Coordinate, -UOM) %>%
  # Convert Value to percentage format (add % symbol)
  mutate(Value = paste0(Value, "%"))


# Rename columns
cleaned_data <- cleaned_data %>%
  rename(
    Provinces = Location,
    Characteristics = Characteristics,
    Adjustments = SCM.Strategic.Adjustments,
    Values = Value,
    Grades = Status
  )


# Export the cleaned data
write.csv(cleaned_data, "supply_chain_data.csv", row.names = FALSE)

# Print confirmation message
cat("Original rows:", nrow(data), "\n")
cat("Cleaned rows:", nrow(cleaned_data), "\n")
