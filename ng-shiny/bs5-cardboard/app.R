#####################################################
#
# bs4dash 부츠트랩 버전 5 R마크다운을 shiny에 가져와서
# 이를 card board로 적용시키려는 시도...
# 실패... 쭉 자동 변환만 시킴 ==> 3x3 아닌 9x1 이 됨
#
#####################################################

library(shiny)
library(knitr)
library(bs4Dash)
library(fresh)

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

