library(shiny)

ui <- fluidPage(
  
  actionButton(
    "next_num", 
    "난수 생성을 위해 클릭하세요."
  ),
  textOutput("rnorm_output")
  
)

server <- function(input, output, session) {
  
  observeEvent(input$next_num, {
    output$rnorm_output <- renderText({
      rnorm(1)
    })
  })
  
}

shinyApp(ui, server)