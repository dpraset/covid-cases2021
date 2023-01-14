library(dplyr)

data <- read.csv("Desktop/INFO201/group7/final-project-group-7/data/Cases by Earliest Specimen Collection Date - County and Age.csv", stringsAsFactors = FALSE)
get_summary_info <- function(dataset) {
  ret <- list()
  #finds length of dataset
  ret$length <- length(dataset)
  #finds number of counties in dataset
  ret$number_of_counties <- dplyr::n_distinct(dataset[, "County"])
  #finds average number of confirmed cases throughout all counties
  ret$avg_confirmed_cases <- mean(dataset[, "ConfirmedCases"])
  #finds least number of confirmed cases in a day
  ret$lowest_confirmed_cases <- min(dataset[, "ConfirmedCases"])
  #finds most number of confirmed cases in a day
  ret$highest_confirmed_cases <- max(dataset[, "ConfirmedCases"])
  #finds sum of all confirmed cases
  ret$total_confirmed_cases <- sum(dataset[, "ConfirmedCases"])
  return(ret)
}