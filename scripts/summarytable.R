library(dplyr)
library(ggplot2)

data <- read.csv("data/Cases by Earliest Specimen Collection Date - County and Age.csv", stringsAsFactors = FALSE)
get_summary_table <- function(data) {
  #creates table of average confirmed cases per day and
  # per age group per county
  avg_per_county <- data %>%
    dplyr::group_by(County) %>%
  dplyr::summarise(Avg_Confirmed_Cases = mean(ConfirmedCases),
                   Avg_Cases_Zero_to_Nineteen = mean(Age.0.19),
                   Avg_Cases_Twenty_to_ThirtyFour = mean(Age.20.34),
                   Avg_Cases_ThirtyFive_to_FourtyNine = mean(Age.35.49),
                   Avg_Cases_Fifty_to_SixtyFour = mean(Age.50.64),
                   Avg_Cases_SixtyFive_to_SeventyNine = mean(Age.65.79),
                   Avg_Cases_Age_Eighty = mean(Age.80.),
                   Avg_Cases_Unknown_Age = mean(UnknownAge))
}