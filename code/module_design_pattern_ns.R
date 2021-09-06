library(shiny)


random_UI <- function(id) {
  
  ns <- NS(id)
  
  list(
    actionButton(
      ns("next_num"), 
      "(모듈) 난수 생성을 위해 클릭하세요."
    ),
    textOutput(ns("rnorm_output"))
  )
}

random_server <- function(id) {
  
  moduleServer(id, function(input, output, session) {
  
    observeEvent(input$next_num, {
      output$rnorm_output <- renderText({
        rnorm(1)
      })
    })
    
  })
  
}

ui <- fluidPage(
  random_UI("module_one")
)

server <- function(input, output, session) {
  random_server("module_one")
  # callModule(random_UI, "module_one")
}

shinyApp(ui, server)
