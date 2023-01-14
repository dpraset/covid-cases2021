# Group 7 Final Project
# Chart 2

# Download packages
library("ggplot2")
library("maps")
library("dplyr")
library("stringr")
library("plotly")

county_map <- function(dataset) {

  # Calculate total cases by county
  cases_by_county <- dataset %>%
    group_by(County) %>%
    summarize("Cases" = sum(ConfirmedCases))
  
  
  # Download shp file, edit county names, join with Covid data
  wash <- map_data("county", "washington") %>%
    mutate(County = paste(str_to_title(subregion), "County")) %>%
    left_join(cases_by_county, by = "County")
  
  
  # Blank map theme from textbook
  blank_theme <- theme_bw() +
    theme(
      axis.line = element_blank(),        # remove axis lines
      axis.text = element_blank(),        # remove axis labels
      axis.ticks = element_blank(),       # remove axis ticks
      axis.title = element_blank(),       # remove axis titles
      plot.background = element_blank(),  # remove gray background
      panel.grid.major = element_blank(), # remove major grid lines
      panel.grid.minor = element_blank(), # remove minor grid lines
      panel.border = element_blank()      # remove border around plot
    )
  
  
  # Plot counties and Covid cases
  ggplot(wash, aes(text = County)) +
    geom_polygon(
      mapping = aes(x = long,
                    y = lat,
                    group = group,
                    fill = Cases),
      color = "white",
      size = .1
    ) +
    coord_map() +
    scale_fill_continuous() +
    labs(fill = "Total Cases",
         title = "Total Covid Cases Per County",
         subtitle = "From March 2020 to July 2021") +
    blank_theme
}


