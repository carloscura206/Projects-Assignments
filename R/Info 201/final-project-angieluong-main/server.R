library(ggplot2)
library(dplyr)
library(scales)
library(tidyr)
library(plotly)

# Load Data Set

server <- function (input, output) {
  output$chart1 <- renderPlotly({
    MHIT_df <- read.csv("MHIT - Answers.csv", stringsAsFactors = FALSE)
    
    MHIT_mod_df <- MHIT_df %>% 
      rename(Q10 = X10.Does.your.employer.provide.mental.health.benefits.as.part.of.healthcare.coverage.,
             Q11 = X11.Is.your.anonymity.protected.if.you.choose.to.take.advantage.of.mental.health.or.substance.abuse.treatment.resources.provided.by.your.employer.,
             Q14 = X14.Do.you.know.the.options.for.mental.health.care.available.under.your.employer.provided.health.coverage.,
             Q15 = X15.Has.your.employer.ever.formally.discussed.mental.health..for.example..as.part.of.a.wellness.campaign.or.other.official.communication..,
             Q16 = X16.Does.your.employer.offer.resources.to.learn.more.about.mental.health.disorders.and.options.for.seeking.help.,
             Q17 = X17.If.a.mental.health.issue.prompted.you.to.request.a.medical.leave.from.work..how.easy.or.difficult.would.it.be.to.ask.for.that.leave.,
             Q56 = X56.Have.you.observed.or.experienced.an.unsupportive.or.badly.handled.response.to.a.mental.health.issue.in.your.current.or.previous.workplace.) %>% 
      select(Year, Q10, Q11, Q14, Q15, Q16, Q17, Q56) %>% 
      filter(Year != 2014, na.rm = TRUE)
    
    
    MHIT_question <- MHIT_mod_df %>% 
      select(Year, Q10, Q11, Q14, Q15, Q16, Q17, Q56) %>% 
      filter(Year == input$select_year, na.rm = TRUE) %>% 
      pivot_longer(cols = c(Q10, Q11, Q14, Q15, Q16, Q17, Q56),
                   names_to = "Question",
                   values_to = "Responses") %>% 
      filter(Question == input$select_question) %>% 
      filter(Responses == "Yes" |
               Responses == "No" | 
               Responses == "I don't know" |
               Responses == "Very easy" |
               Responses == "Somewhat easy" |
               Responses == "Neither easy nor difficult" |
               Responses == "-1" |
               Responses == "Somewhat difficult" |
               Responses == "Very difficult" |
               Responses == "Maybe/Not sure" |
               Responses == "Yes, I experienced" |
               Responses == "Yes, I observed") %>% 
      group_by(Responses) %>% 
      summarize(results = n())
    
    
    questions_chart <- ggplot(data = MHIT_question) + 
      geom_col(mapping = aes(x = input$select_year, y = results, fill = Responses), position = "dodge") +
      labs(title = "Responses to the Selected Survey Question", x = "Year", y = "Results")
    
    ggplotly(questions_chart)
  })
  


 ##Chart 2
  #output$chart2 <- 
    mental_health_df <- read.csv("MHIT - Answers.csv", stringsAsFactors = FALSE)
    #slider input
    output$value <- renderPrint({ input$slider1 })
    
    #Radio Button Input
    output$element<- renderPrint({ input$radio })
    
    #inputs values for bar graph
    output$healthPlot <- renderPlotly({
      mental_health_diag_results <- mental_health_df %>% 
        filter(X3.Country == "United States of America") %>% 
        group_by(Year, X2.Gender, X33.Do.you.currently.have.a.mental.health.disorder.) %>% 
        summarize(results = n()) %>% 
        filter(X2.Gender == "Female" | X2.Gender == "Male", na.rm = TRUE) %>% 
        filter(X33.Do.you.currently.have.a.mental.health.disorder. == input$radio) %>% 
        filter(Year == input$Year)
      
      
      
      #Bar Plot
      #Showcase the male and female responses bar trends at the same time in each respective year
      health_disorder_plot <- ggplot(data = mental_health_diag_results) +
        geom_col(mapping = aes(x = X2.Gender, y = results, color = X2.Gender)) +
        labs(x = "Year", y = "Health Disorder Results", title = "Health Disorders between Gender Identity", color = "Gender")
      
      ggplotly(health_disorder_plot)
      
    })
  
  
  #return(health_disorder_plot)
    
    mental_df <- read.csv("MHIT - Answers.csv", stringsAsFactors = FALSE)
    output$chart3 <- renderPlotly({
      
      bar_data <- mental_df %>% 
        rename(Q55 = X55.If.yes..what.percentage.of.your.work.time..time.performing.primary.or.secondary.job.functions..is.affected.by.a.mental.health.issue.) %>% 
        filter(X50.What.country.do.you.work.in. == "United States of America") %>% 
        group_by(Year, Q55) %>% 
        summarize(results = n())
      
      bar_data[5,2] <- "Unsurveyed"
      bar_data[10,2] <- "Unsurveyed"
      bar_data[15,2] <- "Unsurveyed"
      bar_data[20,2] <- "Unsurveyed"
      
      bar_data$Q55 <- recode(bar_data$Q55, "76NA00%" = "76-100%")
      
      bar_data <- bar_data %>% 
        filter(Year == input$years) %>% 
        filter(Q55 != "Unsurveyed")
      
      chart3 <- ggplot(data = bar_data) +
        geom_col(mapping = aes(x = Year, y = results, fill = Q55), position = "dodge") +
        labs(title = "Percentage of work time \n affected by mental health issues",
             x = "Percent Ranges", y = "Count of Responses", fill = "Key of Percent Ranges")
      
      ggplotly(chart3)
    })
  
}
