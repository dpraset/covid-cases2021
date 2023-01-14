# chart of all ages
library(dplyr)
library(ggplot2)
library(plotly)

# Read data file
# - For some reason, data/'.csv file' didn't work so I used direct
# route from computer
covid_df <- read.csv("data/Cases by Earliest Specimen Collection Date - County and Age.csv", stringsAsFactors = FALSE)

# Creates a dataframe of every age group
all_ages <- select(
  covid_df,
  Age.0.19,
  Age.20.34,
  Age.35.49,
  Age.50.64,
  Age.65.79,
  Age.80.
)

# had to remove the 'UnknownAge' column because it was messing up the graph

# Gets x and y values for graph

# Get age group
age_groups <- colnames(all_ages, do.NULL = TRUE)

# Get sum for each age group
age_sums <- colSums(all_ages, na.rm = FALSE)
age_sums <- c(age_sums)

# Calculate percentages
age_percen <- paste0(round(100 * age_sums / sum(age_sums), 2), "%")

# Function that takes in dataset as a parameter and return graph of data
age_graph_fun <- function(all_ages) {
  # Make all_ages df into new df with sums
  all_ages <- data.frame(
    Age_Groups = c(age_groups),
    value = c(age_sums)
  )
# Make pi chart for the sum of each age group
  age_graph <- ggplot(all_ages, aes(x = "", y = value, fill = Age_Groups)) +
    geom_bar(width = 1, stat = "identity", color = "white") +
    # add a label to add percentages
    geom_text(aes(label = age_percen), position = position_stack(vjust = 0.5)) +
    coord_polar(theta = "y") +
    theme_void() +
    ggtitle("Percentage Summary of Covid-19 Cases Per Age Group") +
    labs(fill = "Age Groups")
  # Display the graph
  age_graph
  # Return it
  return(age_graph)
}
