library(shiny)


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("TIDUS"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput("variable", "variable:",
                  list("Knoener" = "Knoener",
                       "Liz" = "Liz", 
                       "Kula" = "Kula")),
      actionButton("button1", "Submit paper dataset."),
      textAreaInput("chosennames","Enter protein symbols separated by a comma and space.", "HNRNPK",width='400px', height='400px'),
      actionButton("button2", "Submit protein symbols."),
      actionButton("button3", "Compare protein hits.")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Histogram ----
      textOutput("text1"),
      textOutput("text2"),
      textOutput("text3"),
      plotOutput("distPlot")
    )
))



    
    
    
