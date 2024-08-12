library(shiny)
library(markdown)
source("server.R")
source("ui.R")

shinyApp(ui = ui, server = server)