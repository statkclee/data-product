library(shiny)
library(bs4Dash)
library(fresh)

library(shiny)
library(knitr)

ui <- shinyUI(
  fluidPage(
    uiOutput('markdown')
  )
)
server <- function(input, output) {
  output$markdown <- renderUI({
    HTML(markdown::markdownToHTML(knit('openstat_bs4cards.Rmd', quiet = FALSE)))
  })
}

shinyApp(ui, server)

