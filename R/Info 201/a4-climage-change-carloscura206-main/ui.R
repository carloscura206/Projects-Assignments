

library(plotly)

source("co2_summary.R")

climates_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

summary_tab <- tabPanel(
  "Introduction",
  fluidPage(
    h1("Introduction"),
    
    p("
        Climate change has been a rising issue and increases indefinetely 
        overtime. It creates consequences of negative output that effects 
        everyone but harshly targets groups of poverty stricken environments. 
        In this project I  will introduce the data results that venture into 
        CO2 emissions. In my interactive  I will explore the different CO2 
        levels produced from various producer types such as gas, oil, and coal 
        through a line plot from the perspective of countries such as the US,
        China , and France. Within my  interactive visualization,  I will be 
        implementing a radio button option that allows different line plots 
        of the countries represented to show the co2 producer types produced on 
        the screen at the user's choice while also applying a range widget that
        allows the user to pick the range in years to see the change in co2 
        emissions for each element.  In this we can embark a reference on 
        which one produces the most CO2 from the everyday production of the 
        human populaces actions in different countries.
      "),
    
    h1("Summary"),
    p("Climate change is a crisis in our daily lives and is affected by the CO2 
      production created. I first began my analysis by creating a dataframe that
      produces the highest co2 levels from the World's perspective throughout 
      the years in a descending form from highest to lowest. From this I found 
      that the highest co2 production made was from the year 2019 with a value 
      of ", strong(highest_co2_world_produce_2019), ". I also wanted to compare 
      how much this value was different from another year so I looked into the 
      beginning of this dataset from 1750 which formed a value 
      of ", strong(highest_co2_world_produce_1750), ". This shows that 
      the world production of CO2 has changed drastically in an 
      increasing manner."),
   
   p("I then looked over the co2 per capita rates between different years to 
     gain a perspective of either growth/loss in production. From my code, 
     I grasped the info that the average rate in co2 per capita from 1850
     was", strong(avg_co2_1850), " while the average rate in co2 per capita 
     from 2019 was ", strong(avg_co2_2019), ". We can see a drastic change of 
     increase over the years as the value in co2 rates have increased."),
   
    p("Finally Instead of comparing years I wanted to see the drastic 
    difference in co2 rates changed, so I created a dataframe of the co2 per 
    capita of the year 2000 and 1900 and seen the difference in change of co2 
    per capita from these 2 respective years and found value 
    of", strong(avg_difference), " from this we can see a growth rate of co2 
    per capita. CO2 emissions have changed drastically both in rates and in
    production which makes the effects of climate change to be faster and
    thus effecting our environment exceedingly.
    "),
   
    h1("The Dataset Logistics"),
    
    h3("Who collected the data? "),
    p("This data was organized by the organization “Our world in Data” and more
      specifically the data is collected by a multipletude of different 
      disciplinary fields such as researchers, data scientists and engineers.
      The top publishers that documented this dataset are named Hannah Ritchie, 
      Max Roser, Eduoard Mathieu, Bbbie Macdonald, and Pablo Rosado.
      "),
    
    h3("How was the data collected or generated? "),
    p("This data was collected/generated from data of an organization under 
      the name “Global Carbon Project” that releases annual co2 emissions."),
    
    h3("Why was the data collected?"),
    p("Co2 is the leading cause of climate change which is under the danger of 
    being called the “greenhouse effect”, which raises both the land & waters of
    the earth's temperatures.This data was collected to showcase the different 
      co2 emissions within different years & regions. The data collection of 
      CO2 is needed to safeguard protection for the safety of the environment 
      and for human health."),
    
    h3("What are possible limitations or problems with this data? "),
    p("A problem that I saw with this data was that not all countries have 
      values for some years which causes outliers and leverage on what country 
      produces the most/least. A  limitation that I see is that there are 
      multiple ways co2 is produced from a vast majority of figures but this 
      data simplifies it to a small majority of figures which causes an outlier
      of missing causes."),
   
   h1("Conclusion"),
   p("In conclusion CO2 levels are increasing exponentially instead of gradually
    leading to a faster risk of our world temp to increase faster. From my
    visualization we can see that the US is the highest producer in gas & oil 
    co2 emissions while China is the highest producer in coal emissions and 
    France is the lowest emitter from these producers over the years. 
    All in all, our carbon footprint is increasing no matter what based on these 
    results and shows that our actions are affecting the earth in drastic ways 
    that plummets it into negative outcomes.")
   )
)


side_bar_panel_widget <- sidebarPanel(
  
  radioButtons(
              "radio", 
               label = h3("CO2 Producer Types"),
               choices = list(
                   "Gas" = "gas_co2",
                   "Coal" = "coal_co2", 
                   "Oil" = "oil_co2")
               ),
  sliderInput(
    "C02", 
     label = "Year Duration Picked",
     min = min(climates_df$year),
     max = max(climates_df$year),
     value = c(1900, 2000)
  )
  
)


main_panel_co2_plot <-  mainPanel(
  plotlyOutput(outputId = "co2_plot")
) 


ui_climate_tab <- tabPanel(
  "Climate Visualization",
  sidebarLayout(
    side_bar_panel_widget,
    main_panel_co2_plot
  )
)


ui <- navbarPage("CO2 Project ",
                  summary_tab,
                  ui_climate_tab
)


