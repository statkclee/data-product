
# 모듈 UI -------------

plot_ui <- function(id) {
  
  fluidRow(
    column(11, plotOutput(NS(id, "flight_plot"))),
  )
  
}


# 모듈 Server -------------

plot_server <- function(id, df, y_var, threshhold = NULL) {
  
  moduleServer(id, function(input, output, session) {
    
    reactive_plot <- reactive({
      viz_monthly(df = df(), y_var = y_var, threshhold = 10)
    })
    
    output$flight_plot <- renderPlot({
      reactive_plot()
    })

  })
}


