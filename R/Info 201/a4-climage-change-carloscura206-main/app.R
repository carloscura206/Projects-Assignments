library(shiny)
source("ui.R")
source("server.R")

climates_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

shinyApp(ui = ui, server = server)

