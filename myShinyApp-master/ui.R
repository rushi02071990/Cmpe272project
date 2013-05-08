library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Job Prediction"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    
    wellPanel(
        selectInput(inputId="job", 
                    label="Choose an Occupation:",
                    choices = c("Computer and Information Research Scientists"="Computer and Information Research Scientists",
                                "Computer and Information Analysts"="Computer and Information Analysts",
                                "Computer Systems Analysts"="Computer Systems Analysts",
                                "Information Security Analysts"="Information Security Analysts",
                                "Software Developers and Programmers"="Software Developers and Programmers",
                                "Computer programmers"="Computer programmers",
                                "Software Developers, Applications"="Software Developers, Applications",
                                "Software Developers, Systems Software"="Software Developers, Systems Software",
                                "Web Developers"="Web Developers",
                                "Database and Systems Administrators and Network Architects"="Database and Systems Administrators and Network Architects",
                                "Database Administrators"="Database Administrators",
                                "Network and Computer Systems Administrators"="Network and Computer Systems Administrators",
                                "Computer Network Architects"="Computer Network Architects",
                                "Computer Support Specialists"="Computer Support Specialists",
                                "Computer User Support Specialists"="Computer User Support Specialists",
                                "Computer Network Support Specialists"="Computer Network Support Specialists"
                             ),
                    selected="Computer programmers"
                )
    ),
    
    wellPanel(
        selectInput(inputId="jf", label="Job search criteria",
                    choices = c("Number of Jobs"="Employment",
                                "Mean Hourly Wage"= "hourly_mean",
                                "Mean Annual Wage"= "annual_mean",
                                "Median Hourly Wage" = "hourly_median",
                                "Median Annual Wage" = "annual_median"
                                ),
                    selected="Number of Job Openings"
                   )
    ),
     
    numericInput("trendYears", "Predict job situation in following number of year(s):",min=0,max=6, 0),
    submitButton("Predict")
    
    #actionButton("plotButton","<< Plot >>")
    #submitButton("Plot")
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
   plotOutput(outputId = "main_plot"),
   
   h4("Original Known Data"),
   tableOutput("view")
   
    #h4("summary"),
    #verbatimTextOutput(outputId="summary")
  )
))