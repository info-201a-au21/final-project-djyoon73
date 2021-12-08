library("dplyr")
library("tidyverse")
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")


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
  pull(location)

#Which state or territory has the lowest fully vaccinated rate?
lowest_state_fully_vaccinated <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(people_fully_vaccinated_per_hundred == min(people_fully_vaccinated_per_hundred, na.rm = TRUE)) %>%
  pull(location)

#What are the current fully vaccinated rates for all the states?
regional_fully_vaccinated <- state_vaccines %>%
  filter(people_fully_vaccinated_per_hundred >= 0) %>%
  filter(date == max(date)) %>%
  pull(location, people_fully_vaccinated_per_hundred)


#Which state is currently the most effective at using its doses?
highest_dose_usage <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(share_doses_used == max(share_doses_used, na.rm = TRUE)) %>%
  pull(location)

#Which state is currently the least effective at using its doses?
lowest_dose_usage <- state_vaccines %>%
  filter(date == max(date)) %>%
  filter(share_doses_used == min(share_doses_used, na.rm = TRUE)) %>%
  pull(location)


# A function that takes in a dataset and returns a list of info about it:
summary_info <- list()
summary_info$num_observations <- nrow(state_vaccines)
summary_info$highest_state_fullvax <- highest_state_fully_vaccinated
summary_info$lowest_state_fullvax <- lowest_state_fully_vaccinated
summary_info$regional_fullvax <- regional_fully_vaccinated
summary_info$highest_dosage_state <- highest_dose_usage
summary_info$lowest_dosage_state <- lowest_dose_usage


