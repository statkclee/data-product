library(shiny)

ui <- fluidPage(
    
    titlePanel("Shiny 모듈이 없이 구현된 헬로월드"),
    
    fluidRow(
        column(2, textInput("TI_username", label = NULL, placeholder = "이름을 입력하세요.")),
        column(2, actionButton("AB_hello", label = "버튼을 누르세요 !"))
    ),
    br(),
    hr(),
    br(),
    fluidRow(
        column(12, textOutput("TO_Hello_user"))
    )
    
)

server <- function(input, output, session) {
    
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
}

shinyApp(ui = ui, server = server)

