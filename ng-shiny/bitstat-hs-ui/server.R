
library(shiny)

# Define server logic required to draw a histogram
function(input, output) {
  
  hs_dataset <- reactive(
    get(input$hs_dataset_input, asNamespace('hsData'))
  )

  # output$distPlot <- renderPlot({
  #   
  #  print(hs_dataset() )
  #   
  # })
  output$stockTable <-  render_gt({
    
    hs_dataset() %>% 
      gt()
    
  })
}

