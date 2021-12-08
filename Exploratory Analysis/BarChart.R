library("dplyr")
library("tidyverse")
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")

#Separate United States cumulative data total vaccinations and total distribution data 
#to find the numbers over time
us_vaccines <- vaccines %>%
  filter(location == "United States") %>%
  group_by(date) %>%
  summarise(date, people_fully_vaccinated)

#Create table where it has the cumulative data for the columns below on the latest date of each month
#in 2021 for the US.
jan_vaccines <- us_vaccines %>%
  filter(date == "2021-01-31")

feb_vaccines <- us_vaccines %>%
  filter(date == "2021-02-28")

mar_vaccines <- us_vaccines %>%
  filter(date == "2021-03-31")

apr_vaccines <- us_vaccines %>%
  filter(date == "2021-04-30")

may_vaccines <- us_vaccines %>%
  filter(date == "2021-05-30")

jun_vaccines <- us_vaccines %>%
  filter(date == "2021-06-30")

jul_vaccines <- us_vaccines %>%
  filter(date == "2021-07-31")

aug_vaccines <- us_vaccines %>%
  filter(date == "2021-08-31")

sep_vaccines <- us_vaccines %>%
  filter(date == "2021-09-30")

oct_vaccines <- us_vaccines %>%
  filter(date == "2021-10-31")

nov_vaccines <- us_vaccines %>%
  filter(date == "2021-11-21")

us_months_vaccines <- rbind(jan_vaccines, feb_vaccines, mar_vaccines, apr_vaccines,
                            may_vaccines, jun_vaccines, jul_vaccines, aug_vaccines, sep_vaccines, 
                            oct_vaccines, nov_vaccines)
arrange(us_months_vaccines, date)

vaccines_bar_chart <- ggplot(us_months_vaccines) +
  geom_col(mapping = aes(x = date, y = people_fully_vaccinated)) + coord_flip() +
  labs(
    title = "Fully Vaccinated People in US by Month", # plot title
    x = "2021 Ending Date (with data collected) of each Month", # x-axis label
    y = "Number of People Fully Vaccinated", # y-axis label
  )

