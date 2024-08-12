library(tidyverse)


climates_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)


#1A. highest_co2_cases 
highest_co2_producers <- climates_df %>% 
  group_by(year) %>% 
  filter(co2 == max(co2, na.rm = TRUE)) %>% 
  arrange(desc(co2))

#1B. Highest co2 producer from world (World View) 
highest_co2_world_produce_2019 <- highest_co2_producers %>% 
  filter(year == 2019) %>% 
  pull(co2)

#2. co2 level from the beginning of the earliest year dated from 
# dataset (from 1750).

library(tidyverse)
highest_co2_world_produce_1750 <- highest_co2_producers %>% 
  filter(year == 1750) %>% 
  filter(country == "World") %>% 
  pull(co2)

#3. Average co2_per_capita production rates  1850
avg_co2_1850 <- climates_df %>% 
  group_by(year) %>% 
  filter(year == 1850) %>% 
  summarise(co2_per_capita = mean(co2_per_capita, na.rm = TRUE)) %>% 
  pull(co2_per_capita)

#4 Average co2 production from the year 2019
avg_co2_2019 <- climates_df %>% 
  group_by(year) %>% 
  filter(year == 2019) %>% 
  summarise(co2_per_capita = mean(co2_per_capita, na.rm = TRUE)) %>% 
  pull(co2_per_capita)

#5 growth rate of co2_per_capita from 1900 to 2000
#increased in percentage of it
difference_1900_2000 <- climates_df %>% 
  group_by(year) %>% 
  filter(year == 2000 | year == 1900) %>% 
  summarise(co2_per_capita = mean(co2_per_capita, na.rm = TRUE)) 

avg_difference <- difference_1900_2000$co2_per_capita[2] 
                   - 
                  difference_1900_2000$co2_per_capita[1] 
                                                                                                          


#SERVER DF
coal_gas_oil_initial_df <- climates_df %>% select(country, year, coal_co2, gas_co2, oil_co2) %>% group_by(year) %>% filter(country == "World")

