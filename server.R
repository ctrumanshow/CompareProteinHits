library("shiny")
library("DBI")
library("dplyr")
library("dbplyr")
library('pool')
library('dbConnect')
library('VennDiagram')

# CREATE FUNCTION FOR QUERYING SQL
loadData <- function(table) {
  
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = "knoenerdb", host = "localhost", 
                  user = "root", 
                  password = "castellolab")
    
  # Construct the update query by looping over the data fields
  query <- sprintf("SELECT * FROM %s", table)
    
  # Submit and disconnect
  return(dbGetQuery(db, query))
  dbDisconnect(db)
}


# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  overlap = 0
  absent = 0
  updated = vector(mode = "list", length = 0)
  chosendata <- reactive({loadData(input$variable)})
  chosennames <- reactive({unlist(strsplit(input$chosennames, ", "))})
  
  
  observeEvent(input$button1, {
      newish <- input$variable
      output$text1 <- renderText({paste("You have chosen dataset ",newish,".")})
  })
  
  observeEvent( input$button2, {
    output$text2 <- renderText({paste("You have submitted ",length(chosennames())," protein symbols.")})
   
  })

  observeEvent( input$button3, {
    for(i in 1:length(chosennames())){
      if(chosennames()[i] %in% chosendata()$proteins){
        updated <- c(updated,chosennames()[i])
        overlap = overlap + 1
      } else
        absent = absent + 1 
    }     

    output$text3 <- renderText({paste0("You have an overlap of ",overlap," proteins and a distinction of ",absent," proteins.\n Your 
                                       matches are:\n ",paste(updated, " / ", sep=""))})
    
     output$distPlot <- renderPlot({ draw.pairwise.venn(area1 = length(chosennames()), area2 = length(chosendata()$proteins), cross.area = as.numeric(overlap), category = c("FLAG-IP/mCherry", "SPOT-IP/mCherry"),
                        lty = rep("blank", 2), fill = c("light blue", "pink"), alpha = rep(0.5, 2), cat.pos = c(0, 4), cat.dist = rep(0.025, 2), scaled = FALSE)})
     
  })
    
}