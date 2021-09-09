library(shiny)

getwd()

source("module/helloworld_module.R", encoding = "UTF-8")

ui <- fluidPage(
    
    titlePanel("Shiny 모듈 도입하여 구현된 헬로월드"),
    
    fluidRow(
        hello_world_UI(id = "id_1")
    )
    
)

server <- function(input, output, session) {
    
    hello_world_server(id = "id_1")
    
}

shinyApp(ui = ui, server = server)

