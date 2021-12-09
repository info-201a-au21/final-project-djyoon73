library("dplyr")
library("tidyverse")
library("usmap")
library("ggplot2")


vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")

#Summary Information

#How many observations are in the vaccines data set?
obs_vaccines <- nrow(vaccines)

#How many features was data collected on in the vaccines data set?
num_features_vaccines <- ncol(vaccines)

#How many people are fully vaccinated, vaccinated, vaccine does distributed per ten
#thousand people? This is to provide round numbers of for these values and change the "per
#hundred" columns to per ten thousand.
people_fully_vaccinated_per_tenthousand <- vaccines %>%
  select(people_fully_vaccinated_per_hundred) * 100

#Separate United States cumulative data into a different data frame from the states and territories?
us_vaccines <- vaccines %>%
  filter(location == "United States")

regional_vaccines <- vaccines %>%
  filter(location != "United States")

state_vaccines <- regional_vaccines %>%
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
  filter(location != "Long Term Care") 

#Which state has the highest fully vaccinated rate?
highest_state_fully_vaccinated <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(people_fully_vaccinated_per_hundred == max(people_fully_vaccinated_per_hundred, na.rm = TRUE)) %>%
  pull(location, people_fully_vaccinated_per_hundred)

#Which state or territory has the lowest fully vaccinated rate?
lowest_state_fully_vaccinated <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(people_fully_vaccinated_per_hundred == min(people_fully_vaccinated_per_hundred, na.rm = TRUE)) %>%
  pull(location, people_fully_vaccinated_per_hundred)

#What are the current fully vaccinated rates for all the states?
regional_fully_vaccinated <- state_vaccines %>%
  filter(people_fully_vaccinated_per_hundred >= 0) %>%
  filter(date == max(date)) %>%
  pull(location, people_fully_vaccinated_per_hundred)
print(regional_fully_vaccinated)

#Which state is currently the most effective at using its doses?
highest_dose_usage <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(share_doses_used == max(share_doses_used, na.rm = TRUE)) %>%
  pull(location, share_doses_used)

#Which state is currently the least effective at using its doses?
lowest_dose_usage <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(share_doses_used == min(share_doses_used, na.rm = TRUE)) %>%
  pull(location, share_doses_used)

#How many regions have used less than half of their population fully vaccinated?
less_than_half_pop <- regional_vaccines %>%
  filter(date == max(date)) %>%
  filter(people_fully_vaccinated_per_hundred <= 0.5) %>%
  pull(location)

################################################################################

#Aggregate Table

#Separate United States cumulative data into a different data frame from the 
#states and territories?
us_vaccines <- vaccines %>%
  filter(location == "United States")

regional_vaccines <- vaccines %>%
  filter(location != "United States")

state_vaccines <- regional_vaccines %>%
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
  filter(location != "Long Term Care") 

#Group Vaccines by State to form a readable table 
agg_table <- state_vaccines %>% group_by(location) %>%
  summarize(total_vax = sum(total_vaccinations, na.rm = TRUE), 
            total_dist = sum(total_distributed, na.rm = TRUE), 
            total_dist_per_100 = round(mean(distributed_per_hundred, na.rm = TRUE)), 
            people_vax = sum(people_vaccinated, na.rm = TRUE), 
            people_vax_per_100 = round(mean(people_vaccinated_per_hundred, na.rm = TRUE)),
            people_full_vax = sum(people_fully_vaccinated, na.rm = TRUE), 
            people_fullvax_per_100 = round(mean(people_fully_vaccinated_per_hundred, na.rm = TRUE)),
            daily_vax_average = round(mean(daily_vaccinations, na.rm = TRUE)),
            daily_vax_per_million = round(mean(daily_vaccinations_per_million, na.rm = TRUE)), 
            percentage_of_doses_used = round(mean(share_doses_used, na.rm = TRUE) * 100))

################################################################################

#Scatterplot

vaccine_scatterplot <- ggplot(agg_table, aes(
  x = as.numeric(total_dist_per_100),
  y = as.numeric(people_fullvax_per_100)
)) + geom_point() +
  geom_smooth(method=lm, se=FALSE) +
  labs(
    title = "People Vaccinated Per Vaccines Distributed",
    subtitle = "All values calculated are per 100 people.",
    x = "Total Vaccines Distributed",
    y = "People Fully Vaccinated"
  )

################################################################################

#Boxplot

vaccine_boxplot <- boxplot(agg_table$people_fullvax_per_100, main = "Boxplot of People Vaccinated per 100", 
                           ylab = "People Vaccinated per 100",
                           sub = "All Values are per 100 People")

ggplot_boxplot <- ggplot(agg_table, aes(
  x = total_dist_per_100,
  y = people_fullvax_per_100)) + 
  geom_boxplot() +
  labs(
    title = "People Vaccinated Per 100",
    subtitle = "All values calculated are per 100 people.",
    x = "Total Vaccines Distributed",
    y = "People Fully Vaccinated"
  )


################################################################################

#BarChart

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
    x = "Number of People Fully Vaccinated", # x-axis label
    y = "2021 Ending Date (with data collected) of each Month", # y-axis label
  )
