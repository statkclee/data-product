#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output) {
  
  ## 중학교 교과서 ---------------------------------
  output$ms_textbook_01 <- renderUI({
    tags$img(src = "high_school_textbook.png", width="35%")
  })
  output$ms_textbook_02 <- renderUI({
    tags$img(src = "high_school_textbook_01.png", width="35%")
  })
  output$ms_textbook_03 <- renderUI({
    tags$img(src = "prob-stat-textbook-01.png", width="40%")
  })
  
  ## 고등학교 교과서 ---------------------------------
  output$hs_textbook_01 <- renderUI({
    tags$img(src = "prob-stat-textbook-02.png", width="50%")
  })
  output$hs_textbook_02 <- renderUI({
    tags$img(src = "prob-stat-textbook-03.png", width="50%")
  })
  output$hs_textbook_03 <- renderUI({
    tags$img(src = "prob-stat-textbook-04.png", width="40%")
  })
}

