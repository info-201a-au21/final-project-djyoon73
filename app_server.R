library("dplyr")
library("stringr")
library("shiny")
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")
source("app_ui.R")

# interactive page three
#data table when making charts based on regions
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

#interactive page one
# data table for cumulative data for the columns below on the latest date of each month
# in 2021 for the US.

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
library(ggplot2)
library(plotly)

ggplot(data = us_months_vaccines) +
  geom_point(mapping = aes(x = date, y = people_fully_vaccinated_per_hundred))

#interactive page two for map

library("leaflet")
library("usdata")
library("maps")
library("ggplot2")

# Create table for only the states.
state_vaccines <- vaccines %>%
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
  filter(location != "United States") %>%
  filter(location != "District of Columbia")

#Create a data frame that has the states column ready to be joined to the 
#states map with the most current data of their people fully vaccinated
#per hundred.
state_map_vaccines <- state_vaccines %>%
  group_by(location) %>%
  na.omit(people_fully_vaccinated_per_hundred) %>%
  filter(date == max(date), na.rm = TRUE) %>%
  rename(state = location) %>%
  mutate(state = tolower(state)) %>%
  mutate(state = replace(state, state == "new york state", "new york"))

# Join the state data to the U.S. shapefile
state_shape <- map_data("state") %>%
  rename(state = region) %>%
  left_join(state_map_vaccines, by = "state")


# Define the black_theme variable for the minimalist theme
blank_theme <- theme_bw() +
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank()
  )

# Draw the map

# map_plot <- ggplot(state_shape) +
#   geom_polygon(
#     mapping = aes(x = long, y = lat, group = group, fill = people_fully_vaccinated_per_hundred),
#     color = "white",
#     size = .1
#   ) +
#   coord_map() +
#   scale_fill_continuous(low = input$low, high = input$high) +
#   labs(
#     fill = "Number of People Fully Vaccinated per Hundred",
#     title = "US Current Fully Vaccinated People per Hundred"
#   ) +
#   blank_theme
# 
# #interactive page three
tests=data.frame(row.names=c("people_fully_vaccinated","share_doses_used","total_vaccinations", "total_distributed")
                 , val=c("People Fully Vaccinated","Share of Available Doses Used", "Total Vaccine Doses Administered", "Total Vaccine Doses Supplied"))

teststwo=data.frame(row.names=c("share_doses_used","total_vaccinations","total_distributed")
                 , val=c("Share of Available Doses Used","Total Vaccine Doses Administered", "Total Vaccine Doses Supplied"))
teststhree=data.frame(row.names=c("people_fully_vaccinated_per_hundred","distributed_per_hundred")
                    , val=c("Fully Vaccinated People Per Hundred","Vaccines Distributed Per Hundred"))

#Interactive pages setup

server <- function(input, output) {
#   output$map <- renderPlotly({
#   map_plot <- ggplot(state_shape) +
#     geom_polygon(
#       mapping = aes(x = long, y = lat, group = group),
#       color = "white",
#       size = .1
#     ) +
#     coord_map() +
#     scale_fill_continuous(low = "White", high = "Green") +
#     labs(
#       fill = "Number of People Fully Vaccinated per Hundred",
#       title = "US Current Fully Vaccinated People per Hundred"
#     ) +
#     blank_theme
#  
#   
#   #interactive page three
#   tests=data.frame(row.names=c("people_fully_vaccinated","share_doses_used","total_vaccinations", "total_distributed")
#                    , val=c("People Fully Vaccinated","Share of Available Doses Used", "Total Vaccine Doses Administered", "Total Vaccine Doses Supplied"))
#   
#   teststwo=data.frame(row.names=c("share_doses_used","total_vaccinations","total_distributed")
#                       , val=c("Share of Available Doses Used","Total Vaccine Doses Administered", "Total Vaccine Doses Supplied"))
#   
#   return(map_plot)
#   })
  
  output$timePlot <- renderPlotly({
    by_month_vaccines <- us_months_vaccines%>%
      filter(date %in% input$month_input)
    
    my_plot <- ggplot(data = by_month_vaccines, 
                      mapping = aes(x = date, y = !!as.name(input$y_axis_input), 
                                    text = paste("Month:", date, "<br>",
                                                 "People Fully Vaccinated:", people_fully_vaccinated, "<br>",
                                                 "Share of Available Doses Used:", share_doses_used, "<br>",
                                                 "Total Vaccine Doses Administered:", total_vaccinations, "<br>",
                                                 "Total Vaccine Doses Supplied:", total_distributed, "<br>"))) +
      geom_point(stat="identity") + 
      scale_x_discrete(limits=us_months_vaccines$date) +
      theme(axis.text.x = element_text(angle = 45)) +
      labs(
        title = "US Vaccination Rates over Time",
        x = "Month in Year 2021",
        y = tests[input$y_axis_input,])
    
    my_plotly_plot <- ggplotly(my_plot, tooltip = "text")
    
    return(my_plotly_plot)
  })
  
  
  output$map <- renderPlotly({ 
    my_plot_two <- ggplot(state_shape) +
      geom_polygon(
        mapping = aes(x = long, y = lat, group = group, fill = !!as.name(input$mapvar),
                      text = paste("Share of Available Doses Used:", share_doses_used, "<br>",
                                   "Total Vaccine Doses Administered:", total_vaccinations, "<br>",
                                   "Total Vaccine Doses Supplied:", total_distributed, "<br>")),
        color = "white",
        size = .1
      ) +
      coord_map() +
      scale_fill_continuous(low = input$low, high = input$high) +
      labs(
        fill = teststwo[input$mapvar,], #how do I get the fill label to be the variable input chosen
        title = "US Geographical Distribution of Vaccine Rates"
      ) +
      blank_theme
    
    my_map <- ggplotly(my_plot_two, tooltip = "text")
      
      return(my_map)
  })
  
  output$barPlot <- renderPlotly({
    chart_region_vaccines <- current_region_vaccines %>%
      filter(region %in% input$region_input) 
    
    my_plot_three <- ggplot(data = chart_region_vaccines) +
      geom_col(mapping = aes(x = location, y = !!(as.name(input$y_axis)),
                             text = paste("State:", location, "<br>",
                                          "Fully Vaccinated People Per Hundred:", people_fully_vaccinated_per_hundred, "<br>",
                                          "Vaccines Distributed Per Hundred:", distributed_per_hundred, "<br>"))
      ) + 
      coord_flip() +
      labs(
        title = "State Proportion of Vaccines Per Hundred People by US Region", # plot title
        x = "State", # x-axis label
        y = teststhree[input$y_axis,])
    
    my_bar_plot <- ggplotly(my_plot_three, tooltip = "text")
    
    return(my_bar_plot)
  })
  
  
  
}

