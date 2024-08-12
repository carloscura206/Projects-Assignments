library(plotly)
library(bslib)

  # Manually Determine a BootSwatch Theme
  my_theme <- bs_theme(bg = "#6c5b7b", #background color
                     fg = "white", #foreground color
                     primary = "#FCC780" # primary color
  ) 

#################### INTRODUCTION ######################
  # Introductory page tab
    
    intro_tab <- tabPanel(
      # title of the tab
      "Introduction",
      
      fluidPage(
        #Include a Markdown file!
        includeMarkdown("intro-text.md")
      )
      
    )
    
###################### CHART 1 #########################
# -----------------------------------------------------
    # CHART 1: Create panel for widgets (sidebar)
  
  sidebar_panel_widget <- sidebarPanel(
    sliderInput(
      inputId = "select_year",
      label = h3("Year"),
      min = 2017,
      max = 2019,
      value = 2018,
      step = 1,
      sep = ""
    ),
    radioButtons(
      inputId = "select_question",
      label = h3("Question"),
      choices = list("Does your employer provide \n mental health benefits \n 
                       as a part of healthcare coverage? \n" = "Q11",
                     
                     "Is your anonymity protect if you \n choose to take advantage of \n
                       mental health or substance abuse \n treatment resources provided \n
                       by your employer? \n" = "Q10",
                     
                     "Do you know the options for mental \n health care available \n
                       under your employer provided \n health coverage? \n" = "Q14",
                     
                     "Has your employer ever formally \n discussed mental health \n
                       (i.e. as a part of a wellness \n campaign or other official \n
                       communication? \n" = "Q15",
                     
                     "Does your employer offer resources \n to learn more about \n
                       mental health disorders and \n options for seeking help? \n" = "Q16",
                     
                     "If a mental health issue prompted \n you to request a medical \n
                       leave from work, how easy or \n difficult would it be to \n
                       as for that leave? \n" = "Q17",
                     
                     "Have you observed or experienced \n an unsupportive or badly \n
                       handled response to a mental health \n issue in your current \n
                       or previous workplace? \n" = "Q56"
      ),
      selected = "Q11"
    )
  )
# -----------------------------------------------------
    # CHART 1: Create chart in another panel (main)
  main_panel_chart <- mainPanel(
    h1("Interactive Questions and Responses"),
    plotlyOutput(outputId = "chart1"),
    h3("Insight into the humans behind the data"),
    p("As a bit of background into the tech workers that this data \n
      represents, this interactive chart allows you to select a specific \n
      year of data to view as well as the response counts for specific \n
      questions of interest. In most of these questions, a Yes response \n
      would indiciate a positive recognition of mental health and wellness. \n
      This means that the employers, workplaces, and employee legal protection \n       
      recognize mental health, which is the result that we are hoping for. \n          
      Conversely, a No response would indicate a negative relationship with \n
      mental health in the workplace. Additionally, an I don't know response \n
      is not ideal, seeing as it typically means a lack of understanding or \n
      the presence of a gray area surrounding the topic. In other questions \n
      where the responses take the form of a scale of difficulty or short \n
      explanation, the answers speak for themselves."),
    p("After reviewing the data and experimenting with the different settings \n
      of the chart, it becomes obvious that more times than not, the presence \n
      of answers that allude to a negative relationship with mental health \n
      in the workplace is much stronger than a definitive positive association. \n
      In an ideal world, employers, companies, and workplaces would be very \n
      forthcoming on their stances towards employee mental health and would \n
      recognize it as an aspect of employee wellness that needs to be well \n
      cared for. The results of this chart make it very clear that there \n
      is plenty of work to be done in recognizing and caring for tech workers' \n
      mental wellness. Despite this first chart only taking a broad view of all \n
      respondents regardless of country of work, gender, age, race, and more \n
      the stigma and lack of willingness from tech companies to work with \n
      mental wellness is clear.")
  )
    
    
# -----------------------------------------------------
    # CHART 1: Interactive visualization page tab
    
  chart1_tab <- tabPanel(
    "Chart 1",
    sidebarLayout(sidebar_panel_widget,
                  main_panel_chart)
  )
    
    
    
###################### CHART 2 #########################
# -----------------------------------------------------
    # CHART 2: Create panel for widgets (sidebar)
    
    side_bar_panel_widget <- sidebarPanel(
      
      radioButtons(
        "radio", 
        label = h3("Worker Responses"),
        choices = list(
          "Yes",
          "No", 
          "Don't Know")
      ),
      
      sliderInput(
        "Year", 
        label = "Year Diagnostics Picked",
        min = 2017,
        max = 2019,
        value = 2018
      )
      
    )
    
# -----------------------------------------------------
    # CHART 2: Create chart in another panel (main)
  
    main_panel_co2_plot <-  mainPanel(
      h1("Impacts on Gender"),
      plotlyOutput(outputId = "healthPlot"),
      h1("Logistics"),
      p("From this visualization, I looked at my dataframe and focused
      specifically at question 33 (Do you have a mental disorder)
      to see mental disorders for the user to grasps the knowledge of 
      mental disorders  between male & female responses based on the user's 
      choices of seeing the types of responses which consist 
      of Yes, No, and Don't Know radio button choices  
      throughout the years presented. Within this page shows a bar graph that resembles 
      the genders (Male & female) count of the response picked, further understanding 
      how both genders differ from each other overtime."),
    ) 
    
# -----------------------------------------------------
    # CHART 2: Interactive visualization page tab
  
    chart2_panel <- tabPanel(
      "Chart 2",
      sidebarLayout(
        side_bar_panel_widget,
        main_panel_co2_plot
      ),
    )
  
###################### CHART 3 #########################
# -----------------------------------------------------
    # CHART 3: Create panel for widgets (sidebar)
  
    sidebar_panel <- sidebarPanel(
      sliderInput(
        inputId = "years",
        label = h3("Year"),
        min = 2016,
        max = 2019,
        value = 2019,
        step = 1,
        sep = ""
      )
    )
  
# -----------------------------------------------------
    # CHART 3: Create chart in another panel (main)
  
    main_panel <- mainPanel(
      h1("Impacts on Productivity"),
      plotlyOutput(outputId = "chart3"),
      h3("Explanation"),
      p("The chart above shows the percentage ranges that respondents chose \n
        when prompted about how much of their work time is impacted by mental \n
        health issues (with -1 belonging to those without mental health issues.) \n 
        The results show that, despite there being a large proportion of the \n
        (mostly white, mostly male) respondents that chose -1 as an answer to \n
        this question, there is still a visible proportion of individuals who \n
        are impacted by mental wellness. As we explored in chart 2, mental \n
        health issue impact different demographics of tech workers in unique ways. \n
        We can observe that the data used for this observation may be skewed in \n
        favor of those who dominate the spaces within the tech industry. \n
        This also brings up an important point in the shoes of the employers \n
        about reconsidering how they treat mental health as this chart clearly \n
        shows that employee productivity (and therefore products, work, and \n
        potential), are being negatively impacted by mental health issues.")
    )
  
    
# -----------------------------------------------------
    
    # CHART 3: Interactive visualization page tab
    
    chart3_tab <- tabPanel(
      "Chart 3",
      sidebarLayout(sidebar_panel,
                    main_panel)
    )
    
  
##################### CONCLUSION #######################
    
  # Conclusion page tab
    
    conclusion_tab <- tabPanel(
      # title of tab
      "Conclusion",
      fluidPage(
        #Include a Markdown file!
        includeMarkdown("conclusion.md"),
      ),
    )
    

# -----------------------------------------------------
###################### NAV BAR ########################
    
  # Navigation Bar at the top
    
    ui <- navbarPage(
      theme = my_theme,
      # title of nabar
      "Mental Health in the Tech Industry",
      intro_tab,
      chart1_tab,
      chart2_panel,
      chart3_tab,
      conclusion_tab
    )
  