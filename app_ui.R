page_one_mainpanel <- mainPanel(
  
)

# Intro
page_one <- tabPanel(
  "Introduction",
  fluidPage(
    titlePanel("COVID-19 in Washington State"),
    sidebarLayout(position = "right",
                  sidebarPanel (
                    h3("Who are We"),
                    tags$div(
                      tags$li("Joe Severin"),
                      tags$li("Daniel Prasetyo"),
                      tags$li("Bertwocane Adera"),
                      tags$li("Alayna Nomula")
                    )
                  ),
                  mainPanel(
                    h2("", align = "center"),
                    img(src = "covid-19.jpg"),
                    p("Our website allows users to view critical data surrounding COVID-19 in Washington State. 
    We aim to compare the infection rates throughout all Washington State Counties and between various age groups to determine the most at-risk populations. 
    We used data from the", a(href = "https://www.doh.wa.gov/Emergencies/COVID19/DataDashboard#heading58074", "Department of Health"), 
                      "which shows the number of probable and confirmed cases in every Washington county and the number of cases per age group. 
      With a growing number of cases everyday and the emergence of new variants, we believe it is imperative for 
      Washington state residents to stay informed on the case count in their area."
                    )
                  )
    )
  )
)

# Chart 1
page_two <- tabPanel(
  "Age Group Cases",
  fluidPage(
    h2("Chart One"),
   
     # This widget code does work, however you need to run the code in the app_server output$agegraph first so
    # that the objects for the radio buttons are ran into the machine first. We have decided to comment out the widget 
    # because the shiny app would not open without running it first
    
    # sidebarLayout(
    #   position = "right",
    #   sidebarPanel(
    #     radioButtons(
    #       inputId = "radioInput",
    #       label = h3("The sums for each Age Group"),
    #       choices = list("All Ages" = allage,
    #                      "0 to 19" = agezero,
    #                      "20 to 34" = agetwenty,
    #                      "35 to 49" = agethirtyfive,
    #                      "50 to 64" = agefifty,
    #                      "65 to 79" = agesixtyfive,
    #                      "80+" = ageeighty,
    #                      "Unknown Ages" = ageunknown),
    #       # set default button selected
    #       selected = allage
    #     ),
    #     textOutput(
    #       outputId = "message"
    #     )
    #   ),

    mainPanel(
      p(
        "Our data looks to answer what age is the",
        strong("most susceptible to COVID-19"),
        "in Washington. A pie chart was used to represent the data",
        "because it allows for the best visual appearance of multiple groups", 
        "that is easy to follow and understand.", 
        "Using this pie chart, we can see that the age group most", 
        "susceptible to COVID-19 is between the ages of 20 to 34, with a",
        strong("30.59"),
        "percent rate. On the contrary, the least susceptible",
        em("known"), 
        "age group seem to be people who are 80 years old or older, with a",
        strong("2.8"),
        "percent.",
      ),
      br(),
    plotlyOutput(
      outputId = "agegraph"
        ) 
      )
    )
  )





# Chart 2
page_three <- tabPanel(
  "Page three",
  fluidPage(
    theme = bs_theme(version = 4, bootswatch = "yeti"),
    titlePanel("Washington Covid Hotspots"),
    mainPanel(
      leafletOutput(outputId = "wa_counties")
      ),
    sidebarPanel(
      sliderInput(
        inputId = "zoom",           # key this value will be assigned to
        label = "Map zoom level", # label to display alongside the slider
        min = 5,                  # minimum slider value
        max = 10,                  # maximum slider value
        value = 6.25,                 # starting value for the slider
        step = .25,
        ticks = FALSE),
      p("This map compares the cumulative Covid cases each Washington state county 
      has had up until July of 2021. According to this data, King County has had 
      the most confirmed Covid cases; the populous city of Seattle is likely the 
      cause of the inflated numbers. Spokane and Pierce County are home to the 
      second and third most populace cities in Washington, and much like King 
      county, have had more Covid cases than others."),
    ),
  ),
)
# Chart 3
page_four <- tabPanel(
  "Probable Cases Vs Confirmed Cases",
  fluidPage(
    h2("Bar Chart"),
    p("This chart shows a comparison of the probable and confirmed cases within king County. 
       From the dataset, 19 dates are chosen in order to show the two types of cases. 
       A bar graph is the best way to show this data because it is a good way to have 
       side by side comparison of categorical data. This graph not only shows the rate
       of confirmed covid cases in King County, it also shows the difference between 
       probable cases and confirmed cases over time. The main observation is that 
       there is a slow increase of probable cases while there is a fast increase 
       of confirmed cases. This might be because it is more difficult to accurately
       calculate probable cases. But overall, probable cases increase slowly, while 
       confirmed cases increase quickly and stay high."),
  ),
  plotlyOutput(
    outputId = "probable_confirmed"
  )
)

# Summary
page_five <- tabPanel(
  "Summary",
  fluidPage(
    h2("Main Takeaways"),
    tags$div(
      tags$p("In our first chart, we see theconfirmed cases for different age groups in Washington.
      You can see that the age group with the highest rate of confirmed cases
      throughout all Washington Counties was 20-34 year olds, while individuals of
      80 years old and above had the lowest rate. This could be due to higher rates of testing
      in the younger age groups of 20-34, or it could mean that there is a higher risk for people
      in that age group."),
      tags$p("In King County, the peak of infection rates occurred during November
             and December of 2020. This could be due to increased rates of travel 
             during the holiday season."),
      tags$p("In Washington State, King County had the highest number of cases, followed
             by Pierce and Spokane County , which is expected due to their significantly
             higher population.")
    )
  )               
) 

ui <- fluidPage(
  includeCSS("www/style.css"),
  navbarPage(
    "Final Project",
    page_one,
    page_two,
    page_three,
    page_four,
    page_five
  )
)