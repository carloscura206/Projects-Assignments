library("shiny")
library("dplyr")
library("ggplot2")

source("ui.R")

climates_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

#df of gas,oil, and coal emissions
coal_gas_oil_initial_df <- climates_df %>% 
  select(country, year, coal_co2, gas_co2, oil_co2) %>% 
  group_by(year) %>% 
  filter(country == "World")



#Apply the code outside the server function

server <- function(input, output) {
  #slider input
  output$value <- renderPrint({
    
    input$slider1 
    
    })
  
  #Radio Button Input
  output$element <- renderPrint({ 
    
     input$radio
    
    })

  #Plot(line plot)
  output$co2_plot <- renderPlotly({
    
    coal_gas_oil_initial_df <- climates_df %>% 
      select(country, year, coal_co2, gas_co2, oil_co2) %>% 
      group_by(country, year) %>% 
      
      #summarize the oil,gas, and coal productions by US, China and France to 
      #showcase the difference between them.
      #line plots at the same time for each country from the same co2 element
      
      filter(country %in% c("United States", "China", "France")) %>% 
      filter(year >= input$C02[1], year <= input$C02[2])
      

    
    #Line Plot
    #Showcase different trneds at the same time based on users choice of element
    coal_gas_oil_co2_plot <- ggplot(data = coal_gas_oil_initial_df) +
      geom_line(mapping = aes(
        x = year, 
        y = !!as.name(input$radio), 
        color = country)) +
      
      labs(x = "Year", 
           y = "CO2 Emissions", 
           title = "Country CO2 production", 
           color = "Country")
      
    ggplotly(coal_gas_oil_co2_plot)
    
  })
}

