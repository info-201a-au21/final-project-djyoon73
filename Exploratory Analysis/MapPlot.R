#Download the dataset
library("dplyr")
vaccines <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")

# Plot a map
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
  mutate(state = replace(state, state == "new york state", "new york")) %>%
  summarise(state, people_fully_vaccinated_per_hundred)

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
map_plot <- ggplot(state_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = people_fully_vaccinated_per_hundred),
    color = "white",
    size = .1
  ) +
  coord_map() +
  scale_fill_continuous(low = "#132B43", high = "Red") +
  labs(
    fill = "Number of People Fully Vaccinated per Hundred",
    title = "US Current Fully Vaccinated People per Hundred"
  ) +
  blank_theme
