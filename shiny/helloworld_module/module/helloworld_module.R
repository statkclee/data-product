# Function for module UI
hello_world_UI <- function(id) {
  
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      column(2, textInput(ns("TI_username"), label = NULL, placeholder = "이름을 입력하세요.")),
      column(2, actionButton(ns("AB_hello"), label = "버튼을 누르세요 !"))
    ),
    hr(),
    fluidRow(
      column(12, textOutput(ns("TO_Hello_user")))
    )
  )
  
}

# 모듈 함수
hello_world_server <- function(id) {
  
  moduleServer(id, function(input, output, session) {
  
    # 버튼을 클릭했을 때 텍스트 입력값을 리액티브로 반환
    name <- eventReactive(input$AB_hello, {
      return(input$TI_username)
    })
    
    # 헬로월드 출력결과
    output$TO_Hello_user <- renderText({
      if (name() %in% "") {
        return("헬로 월드 !")
      } else {
        return(paste("안녕 세상 ~~~", name(), "님, 환영합니다!!!"))
      }
    })
  
  })
}