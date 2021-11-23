library("dplyr")
library("tidyverse")
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")
View(vaccines)


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
View(state_vaccines)

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
View(agg_table)


#Create Scatterplot
vaccine_scatterplot <- plot(agg_table$total_dist_per_100, agg_table$people_fullvax_per_100, main = "People Vaccinated per Vaccines Distributed", 
     xlab = "Total Vaccines Distributed",
     ylab = "People Fully Vaccinated",
     sub = "All Values are per 100 People", col.sub = "red")





