library(shiny)


random_UI <- function() {
  list(
    actionButton(
      "next_num", 
      "(함수) 난수 생성을 위해 클릭하세요."
    ),
    textOutput("rnorm_output")
  )
}

random_server <- function(input, output, session) {
  
  observeEvent(input$next_num, {
    output$rnorm_output <- renderText({
      rnorm(1)
    })
  })

}

ui <- fluidPage(
  random_UI()
)

server <- function(input, output, session) {
  random_server(input, output, session)
}

shinyApp(ui, server)

