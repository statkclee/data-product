slider_input_ui <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::tagList(
    
    shiny::sliderInput(inputId = ns("bins"),
                       label   = "Number of bins:",
                       min     = 1,
                       max     = 50,
                       value   = 30),
    
    br(),
    
    shiny::actionButton(inputId = ns("click"),
                        label   = "Click Me"),
    
    br()
    
  )
  
}
slider_input_server <- function(id) {
  
  shiny::moduleServer(id, function(input, output, session) {
      
      shinyjs::click(id = "click")
      
      return(
        list(
          bins       = shiny::reactive(input$bins),
          action_btn = shiny::reactive(input$click)
        )
      )
      
    }
    
  )
  
}
