probable_confirmed_cases <- function(dataset) {
#load in library
library(dplyr)
library("ggplot2")
library(tidyr)
library(reshape2)
library(tidyverse)

rm(list = ls())

#load in data
covid_data <- read.csv("data/Cases by Earliest Specimen Collection Date - County and Age.csv",
                       stringsAsFactors = FALSE)

#subset just to show king county information
king_county <- covid_data %>%
               select(County, WeekStartDate, ProbableCases, ConfirmedCases) %>%
               filter(County == "King County") %>%
               mutate(year = substring(WeekStartDate, 1, 10)) %>%
               slice(seq(1, n(), by = 4)) %>%
               mutate(County = as.numeric(County))

# formatted the data frame so that probable cases and confirmed
# cases will be in one column. This will make it easier to make a bar graph
formatted_king_county <- melt(king_county[, c("year", "ProbableCases",
                                             "ConfirmedCases")], id.vars = 1)

#bar graph of a comparison of probable cases and confirmed cases
ggplot(formatted_king_county, aes(x = year, y = value)) +
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge",
           color = "black", size = 0.5, alpha = 0.7) +
  theme_minimal() + scale_fill_discrete(name = "Category of \nCOVID-19 Cases") +
  labs(x = "Date", y = "COVID-19 Cases", title = "Probable Cases Vs.
       Confirmed Cases in King County") +
  theme(legend.position = "right", axis.text.x = element_text(angle = 45,
                                                              hjust = 0.8)) +
  scale_y_log10(oob = scales::squish_infinite)

}
