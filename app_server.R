server <- function(input, output){
  covid_data <- read.csv("data/Cases by Earliest Specimen Collection Date - County and Age.csv",
                         stringsAsFactors = FALSE)
  
  output$agegraph <- renderPlotly({
    all_ages <- select(
      covid_data,
      Age.0.19,
      Age.20.34,
      Age.35.49,
      Age.50.64,
      Age.65.79,
      Age.80.,
      UnknownAge
    ) # I can use the unknown ages because plot_ly moves the 
    # percentage labels around
    
    # Get age group
    age_groups <- colnames(all_ages, do.NULL = TRUE)
    # Get sum for each age group
    age_sums <- colSums(all_ages, na.rm = FALSE)
    age_sums <- c(age_sums)
    
    all_ages <- data.frame(
      Age_Groups = c(age_groups),
      value = c(age_sums)
    )
    
    #radio button sums
    allage <- sum(age_sums)
    agezero <- sum(age_sums[1])
    agetwenty <- sum(age_sums[2])
    agethirtyfive <- sum(age_sums[3])
    agefifty <- sum(age_sums[4])
    agesixtyfive <- sum(age_sums[5])
    ageeighty <- sum(age_sums[6])
    ageunknown <- sum(age_sums[7])
    
    #rewrote chart1 function code into plot_ly  
    agegraph <- plot_ly(all_ages, labels = age_groups, values = age_sums, type = 'pie')
    agegraph <- agegraph %>%
      layout(title = "Percentage Summary of Covid-19 Cases Per Age Group",
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    agegraph
  })
  
  # Chart1 age group
  output$message <- renderText({
    msg <- paste0("The sum of that age group is: ", input$radioInput, " people")
  })

  
  # Chart 2
  output$wa_counties <- renderLeaflet({
    
    covid_data <- read.csv("data/Cases by Earliest Specimen Collection Date - County and Age.csv")
    
    # Calculate total cases by county
    cases_by_county <- covid_data %>%
      group_by(County) %>%
      summarize("Cases" = sum(ConfirmedCases))
    
    # Download shp file, edit county names, join with Covid data
    wash <- map_data("county", "washington") %>%
      mutate(County = paste(str_to_title(subregion), "County")) %>%
      left_join(cases_by_county, by = "County")
    
    # Average lat and long data and simplify wash df
    wa_locations <- wash %>% 
      group_by(County) %>% 
      summarize(avg_lat = mean(lat), avg_long = mean(long), Cases = mean(Cases))
    
    # Create the map of Seattle, specifying the data to use and a layer of circles
    leaflet(data = wa_locations) %>% # specify the data you want to add as a layer
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -120.740135, lat = 47.751076, zoom = input$zoom) %>% # focus on Seattle
      addCircles(
        lat = ~avg_lat, # a formula specifying the column to use for latitude
        lng = ~avg_long, # a formula specifying the column to use for longitude
        label = ~County,
        popup = paste0("Number of cases in ", wa_locations$County, ": ", wa_locations$Cases), # a formula specifying the information to pop up
        radius = ~Cases/5+20000, # radius for the circles, in meters
        stroke = FALSE # remove the outline from each circle
      )
  })
  
  
  output$probable_confirmed <- renderPlotly({
  
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
  })
}
