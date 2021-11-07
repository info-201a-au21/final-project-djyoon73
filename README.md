# Final Project
By: Sai Raksha Rayala, Da Jeong Yoon, and Pranav Prabhakar
## Project Proposal
### Domain of Interest
Our group is interested in the field and domain of COVID vaccination. We are interested in this, because its data is relevant to how our lives will proceed in these next few months and years, as public health and the end of the pandemic depends on the rate of vaccination. Our team is interested in seeing how other factors may influence the rate of vaccinations such as age, geographic location, political leanings, and more. We believe this domain is pertinent to our current and future lives!

We hope to answer inquiries such as the following questions:
- Which age groups have been the most vaccinated against COVID-19?
- Does the political leanings of geographic locations correlate with their rate of vaccinations?
- Which geographic locations have the highest rate of fully vaccinated people and distributing booster shots?
- What proportion of people are vaccinated in different geographies?

### Finding Data
#### Data Sources
We have identified the three following sources for data that would be relevant to our domain:
- To see the breakdown in America, we can look at the [Bloomberg Covid Vaccine Tracker](https://raw.githubusercontent.com/BloombergGraphics/covid-vaccine-tracker-data/master/data/current-usa.csv. ) data publicly made available on GitHub.
- Another option is the data from the [Google Cloud tracker](https://storage.googleapis.com/covid19-open-data/covid19-vaccination-search-insights/Global_vaccination_search_insights.csv ) which tracks global COVID vaccine rates along with the vaccine eligibility and intent.
- A third source is a compiled [Our World in Data](https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv.) COVID vaccine tracker that breaks down the vaccination rate based on population distribution.

#### Data Collection & Description
Our three sources of data were collected in the following ways:
- Bloomberg Covid Vaccine Tracker: This data was collected from government websites, official statements and Bloomberg interviews, as well as third-party sources including the World Health Organization, Johns Hopkins University, and Our World In Data.
- Google Cloud Tracker: This data was collected through Google searches split in across three categories: COVID-19 vaccination, vaccination intent, and safety and side effects. The data represents Google Search users and might not represent the exact behavior of a wider population.
- Our World In Data: This data was collected by Our World In Data. For global vaccination data, metrics were drawn from the latest revision of the United Nations World Population Prospects. For United States vaccination data, metrics relied on daily updated data by the United States Centers for Disease Control and Prevention.

#### Data Observations (Rows)
- Bloomberg global data has 223 rows. The USA data has 66 rows.
- Google Cloud Tracker’s global data has 623,624 rows.
- Our World In Data’s world data has 131,500 rows.

#### Data Features (Columns)
- Bloomberg’s global data has 7 columns. The USA data has 9 columns.
- Google Cloud Tracker’s global data has 13 columns.
- Our World In Data’s world data has 65 columns.

#### Questions to be Answered
The following are questions that can be answered using the above datasets:
- Bloomberg’s data includes columns such as population, people vaccinated, and completed vaccinations. We can ask questions such as:
  - What are the ratios of people vaccinated against the country's population?
  - What countries have the highest and lowest ratios?
  - What might this show about the country?
  - Is there a discrepancy between the number of people vaccinated and completed vaccination? If so, what does this tell?
- Google Cloud Tracker’s global data includes columns such as country, vaccination intent, number of vaccinations, and side effects. We can ask questions such as:
  - Is there a correlation between vaccination intent and the number of vaccinations?
  - What is the proportion?
  - How does vaccination intent vary by country and country region? What does this tell us?
- Our World In Data’s world data has many more columns, and new information such as population density, median age, number of people aged 65 and older, new cases, total vaccinations, and much more. We can answer questions such as:
  - How does the number of cases relate to the median age of people by country?
  - How does vaccination rate compare to the median age of people by country?
  - Does population density have a correlation with the number of cases?
  - What is the average ratio between the two variables?
