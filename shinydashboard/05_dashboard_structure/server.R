server <- function(input, output, session) {
    set.seed(122)
    histdata <- rnorm(500)
    
    output$plot1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
    })
    
    output$clicked <- renderText({
        paste("You've selected:", input$tabs)
    })
}