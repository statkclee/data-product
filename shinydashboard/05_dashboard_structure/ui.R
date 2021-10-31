library(shiny)
library(shinydashboard)

# header <- dashboardHeader()
# sidebar <- dashboardSidebar()
# body <- dashboardBody()
# dashboardPage(header, sidebar, body)

header <- 
  dashboardHeader(title = "제20대 대통령선거",
    dropdownMenu(type = "messages",
                 messageItem(
                   from = "Sales Dept",
                   message = "Sales are steady this month."
                 ),
                 messageItem(
                   from = "New User",
                   message = "How do I register?",
                   icon = icon("question"),
                   time = "13:45"
                 ),
                 messageItem(
                   from = "Support",
                   message = "The new server is ready.",
                   icon = icon("life-ring"),
                   time = "2014-12-01"
                 )
    )
  )

sidebar <- 
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("득표현황", tabName = "vote_tab", startExpanded = FALSE,
               menuSubItem("전국 득표율", tabName = "sido_vote"),
               menuSubItem("시도별 득표율", tabName = "sigungu_vote")
      ),
      menuItem("지도", tabName = "map"),
      menuItem("다운로드", tabName = "download"),
      menuItem("신지도", icon = icon("bar-chart-o"), startExpanded = TRUE,
               menuSubItem("시도", tabName = "sido_map"),
               menuSubItem("구시군", tabName = "sigungu_map")
      ),
      menuItem("연결사례", tabName = "connect"),
      textOutput("clicked")
    )
  )

body <- 
  dashboardBody(
    tabItems(
      tabItem("vote_tab", div(p("Dashboard tab content"))),
      tabItem("sido_vote", "시도 득표"),
      tabItem("sigungu_vote", "시군구 득표"),
      tabItem("map", "지도"),
      tabItem("download", "다운로드"),
      tabItem("sub_map", "지도 상위메뉴"),
      tabItem("sido_map", "시도 지도"),
      tabItem("sigungu_map", "시군구 지도"),
      tabItem("connect", 
              fluidRow(
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                ),
                box(plotOutput("plot1", height = 250))
              )
            )
    )
  )

dashboardPage(header, 
              sidebar, 
              body)
