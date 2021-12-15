library("dplyr")
library("stringr")
library("shiny")
library("plotly")
library("mapproj")
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")

#introduction tab
intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    h2(style = "color:green", "Introduction"),
    img(src = "https://news.harvard.edu/wp-content/uploads/2021/11/iStock-Vaccine-and-nurse-1200x800.jpg", width = "50%", align = "right"),
    p("Our group is interested in the field/domain of COVID vaccination in America. 
    We are interested in this because it is relevant to how our lives will proceed in 
    these next few months and years, as public health and the end of the pandemic depends 
    on the rate of vaccination. Our team is interested in seeing how different parts of the 
    United States are proceeding in terms of vaccination, fully vaccinated people, and how 
    many of the doses they are using, since there's been talks of vaccine doses wastage."),
    p("The data set we're using was collected by Our World In Data. For global vaccination data,
      metrics were drawn from the latest revision of the", em("United Nations World Population Prospects."), 
      "For United States vaccination data, which is the metrics we're relying on, the values were 
      taken from daily updated data by the", em("United States Centers for Disease Control and Prevention."), 
      "We focused on the United States data to inform our understanding on how vaccination efforts 
      are going in our country."),
    h2(style = "color:red", "Key Questions"),
    p("The key questions we are hoping to answer are as follows:"),
    p("   - How has the total people vaccinated, as well as dosage statistics, changed over time in 2021?"),
    p("   - How does the share of available, administered, and supplied doses vary by state?"),
    p("   - How does the proportion of people vaccinated vary by region?"),
    p("In order to answer the above questions, we have created three interactive visualisations that feature different 
      aspects of our dataset. For the first question, we broke down our data by month, and plotted a user choice of 
      values over the year 2021. Our map features a color gradient showing the proportion of the chosen value, and 
      we grouped our data by each State in order to do this. The answer to our final question features a barchart, where
      we grouped our data by region and added an x-axis slider for ease of viewing.")
  )
)

## INTERACTIVE PLOT ONE
us_vaccines <- vaccines %>%
  filter(location == "United States") %>%
  group_by(date)

jan_vaccines <- us_vaccines %>%
  filter(date == "2021-01-31") %>%
  mutate(date = "January")

feb_vaccines <- us_vaccines %>%
  filter(date == "2021-02-28") %>%
  mutate(date = "February")

mar_vaccines <- us_vaccines %>%
  filter(date == "2021-03-31") %>%
  mutate(date = "March")

apr_vaccines <- us_vaccines %>%
  filter(date == "2021-04-30") %>%
  mutate(date = "April")

may_vaccines <- us_vaccines %>%
  filter(date == "2021-05-30") %>%
  mutate(date = "May")

jun_vaccines <- us_vaccines %>%
  filter(date == "2021-06-30") %>%
  mutate(date = "June")

jul_vaccines <- us_vaccines %>%
  filter(date == "2021-07-31") %>%
  mutate(date = "July")

aug_vaccines <- us_vaccines %>%
  filter(date == "2021-08-31") %>%
  mutate(date = "August")

sep_vaccines <- us_vaccines %>%
  filter(date == "2021-09-30") %>%
  mutate(date = "September")

oct_vaccines <- us_vaccines %>%
  filter(date == "2021-10-31") %>%
  mutate(date = "October")

nov_vaccines <- us_vaccines %>%
  filter(date == "2021-11-30") %>%
  mutate(date = "November")

us_months_vaccines <- rbind(jan_vaccines, feb_vaccines, mar_vaccines, apr_vaccines,
                            may_vaccines, jun_vaccines, jul_vaccines, aug_vaccines, sep_vaccines, 
                            oct_vaccines, nov_vaccines)

months_unique <- unique(us_months_vaccines$date)

#side panel for selecting y-axis variable and month for page one
plot_sidebar <- sidebarPanel(
  selectInput(
    inputId = "y_axis_input",
    label = "Vaccination Variable",
    choices = list("People Fully Vaccinated" = "people_fully_vaccinated",
                   "Share of Available Doses Used" = "share_doses_used",
                   "Total Vaccine Doses Administered" = "total_vaccinations",
                   "Total Vaccine Doses Supplied" = "total_distributed"),
    selected = "people_fully_vaccinated"
  ),
  checkboxGroupInput(
    inputId = "month_input",
    label = "Month",
    choices = months_unique,
    selected = months_unique
  )
)

#main panel for the plot for page one
plot_main <- mainPanel(
  plotlyOutput(outputId = "timePlot")
)

#main panel and side panel combined
plot_one_tab <- tabPanel(
  "US Vaccine Data over Time",
  titlePanel("US Vaccine Data Over Time"),
  sidebarLayout(
    plot_sidebar,
    plot_main
  )
)

##INTERACTIVE PAGE TWO 
#side panels for page two, selection and Ray and Ivanna said it was okay to make
#a color widget

map_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "mapvar",
    label = "Variable to Map",
    choices = list(
      "Share of Available Doses Used" = "share_doses_used",
      "Total Vaccine Doses Administered" = "total_vaccinations",
      "Total Vaccine Doses Supplied" = "total_distributed"
    )
  ),
  selectInput(
    inputId = "low",
    label = "Gradient Low",
    choices = c("Red", "Blue", "Green", "Orange"),
    selected = "Green"
  ),
  selectInput(
    inputId = "high",
    label = "Gradient High",
    choices = c("Red", "Blue", "Green", "Orange"),
    selected = "Blue"
  )
)

#main panel for page two
map_main_content <- mainPanel(
  plotlyOutput("map")
)

#main and side panels combined for page two
plot_two_tab <- tabPanel(
  "US Vaccine Data Geographically",
  titlePanel("US Vaccine Data Geographically"),
  sidebarLayout(
    map_sidebar_content,
    map_main_content
  )
)
## INTERACTIVE PAGE THREE 
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")

#data loaded in ui for the interactive chart 
current_vaccines <- vaccines %>%
  filter(location != "United States")%>%
  filter(location != "American Samoa") %>%
  filter(location != "Guam") %>%
  filter(location != "Federated States of Micronesia") %>%
  filter(location != "Indian Health Svc") %>%
  filter(location != "Marshall Islands") %>%
  filter(location != "Dept of Defense") %>%
  filter(location != "Puerto Rico") %>%
  filter(location != "Virgin Islands") %>%
  filter(location != "Northern Mariana Islands") %>%
  filter(location != "Republic of Palau") %>%
  filter(location != "Bureau of Prisons") %>%
  filter(location != "Veterans Health") %>%
  filter(location != "Long Term Care") %>%
  filter(location != "District of Columbia") %>%
  group_by(location) %>%
  na.omit(date) %>%
  filter(date == max(date), na.rm = TRUE)

ne_vaccines <- current_vaccines %>%
  filter(location %in%  c("New Hampshire", "Vermont", "Massachusetts", 
                          "New York State", "Rhode Island", "Connecticut",
                          "New Jersey", "Pennsylvania", "Maine")) %>%
  mutate(region = "Northeast")

west_vaccines <- current_vaccines %>%
  filter(location %in%  c("Montana", "Idaho", "Wyoming", "Colorado", "New Mexico", 
                          "Arizona", "Utah", "Nevada", "California", "Oregon", 
                          "Washington", "Alaska", "Hawaii")) %>%
  mutate(region = "West")

south_vaccines <- current_vaccines %>%
  filter(location %in%  c("Delaware", "Maryland", "Virginia", "West Virginia", 
                          "Kentucky", "North Carolina", "South Carolina", "Tennessee", "Georgia", 
                          "Florida", "Alabama", "Mississippi", "Arkansas", "Louisiana", "Texas",  
                          "Oklahoma")) %>%
  mutate(region = "South")

midwest_vaccines <- current_vaccines %>%
  filter(location %in%  c("Ohio", "Michigan", "Indiana", "Wisconsin", "Illinois", 
                          "Minnesota", "Iowa", "Missouri", "North Dakota", "South Dakota", "Nebraska", 
                          "Kansas")) %>%
  mutate(region = "Midwest")

current_region_vaccines <- rbind(ne_vaccines, west_vaccines, south_vaccines, midwest_vaccines)

region_unique <- unique(current_region_vaccines$region)

# sidepanels of selection and slider for page three
bar_chart_sidebar <- sidebarPanel(
  selectInput(
    inputId = "region_input",
    label = "US Region",
    choices = region_unique,
    selected = region_unique
  ),
  selectInput(
    inputId = "y_axis",
    label = "Vaccine Variables per Hundred People",
    choices = list("Fully Vaccinated People per Hundred" = "people_fully_vaccinated_per_hundred",
                   "Vaccines Distributed per Hundred" = "distributed_per_hundred"),
    selected = "people_fully_vaccinated_per_hundred"
  )
)

#main panel for page three
plot_main_three <- mainPanel(
  plotlyOutput(outputId = "barPlot")
)

#main and side panels combined for page three
plot_three_tab <- tabPanel(
  "Vaccine Data per Hundred by US Region",
  titlePanel("Vaccine Data per Hundred by US Region"),
  sidebarLayout(
    bar_chart_sidebar,
    plot_main_three
  )
)

#summary takeaways tab
summary_takeaways <- tabPanel(
  "Summary Takeaways",
  titlePanel("Key Summary Takeaways"),
  fluidPage(
    tags$div(
      tags$p(
        "Our first visualization of US Vaccine data over time shows that over the 
        12 months since the vaccine became available, the number of people fully 
        vaccinated steadily increased, with the most rapid growth occurring between
        February of 2021 to June of 2021. The total number of vaccines administered as well 
        as the total number of vaccines supplied follow a very similar trend to the 
        number of people fully vaccinated, proving a positive correlation between 
        the two variables. However, the share of available doses used do not follow 
        a similar trend. In January, the share of available doses was very low at only around 62.3%
        of total doses being utilized. After, the share of doses used increases 
        to 78% and continues to increase to reach a peak of 86.3% of vaccines being used. 
        Regardless, this still shows that not all shares of available doses are being
        used and that there is a wastage of vaccines."),
      tags$p(
        "Our second visualization displaying US vaccine data geographically shows the
        similarity of total vaccine doses supplied to total vaccine doses administered. 
        California has the highest number of total vaccine doses supplied with little over 7 million,
        as well as the highest number of total vaccine doses administered with little over 6 million
        doses administered. Again, we notice a gap between the number of vaccines supplied versus
        the number of vaccines administered, which can be seen by selecting the share of available doses used. 
        Alabama utilizes the least share of available doses, at 67.8% of total available
        doses used."),
      tags$p(
        "Our third visualization looks at the proportion of people fully vaccinated
        by region. We can conclude that the Northeast states have the highest proportion
        of people fully vaccinated, with an average of 70% of people being fully vaccinated. 
        On average, 58% of people in the Western states, 55.6% of people in the 
        Southern states, and 56 % of people in the Midwestern states being fully vaccinated.
        Vermont had the highest state proportion of people fully vaccinated, at 74.38% being 
        fully vaccinated."),
      tags$p(
        "These various visualizations show that the US needs to increase efficiency in administering 
        doses to maximize usage. This also shows that many regions of the US, especially the Western, Southern, 
        and Midwestern states have long ways to go before the majority of the population is fully vaccinated."
      ),
      h2("Major Takeaways"),
      tags$b(" - Although there is a positive correlation between vaccine supply and administration, we still see that
             available COVID-19 vaccines are not being fully utilised."),
      tags$p(),
      tags$b(" - Geographically, very few states are using their share of vaccines effectively, with Wisconsin and West 
             Virginia being among the best. On the other hand, Idaho and Alabama are the most ineffective states in 
             terms of utilizing vaccine supply."),
      tags$p(),
      tags$b(" - In terms of region, the Northeast United States has the highest proportion of people fully vaccinated. 
             On the contrary, the Southern region has the least amount of people fully vaccinated.")
    )
  )
)

#final user interactive output
ui <- navbarPage(
  "US Covid Vaccine Rates",
  intro_tab,
  plot_one_tab,
  plot_two_tab,
  plot_three_tab,
  summary_takeaways
)
