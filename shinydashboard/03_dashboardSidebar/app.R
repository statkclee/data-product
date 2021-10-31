## app.R ##
# https://stackoverflow.com/questions/48210709/show-content-for-menuitem-when-menusubitems-exist-in-shiny-dashboard
library(shiny)
library(shinydashboard)

convertMenuItem <- function(mi,tabName) {
    mi$children[[1]]$attribs['data-toggle']="tab"
    mi$children[[1]]$attribs['data-value'] = tabName
    if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
        mi$attribs$class=NULL
    }
    mi
}

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
        menuItem("득표현황", tabName = "vote_tab"),
          menuSubItem("전국 득표율", tabName = "sido_vote"),
          menuSubItem("시도별 득표율", tabName = "sigungu_vote"),
        menuItem("지도", tabName = "map"),
        menuItem("다운로드", tabName = "download"),
        convertMenuItem(menuItem("지도", tabName = "sub_map", icon = icon("map"), selected = FALSE, show = FALSE,
                                 menuSubItem("시도", tabName = "sido_map"),
                                 menuSubItem("구시군", tabName = "sigungu_map")), "sub_map")
    ),
    
    dashboardBody(
        tabItems(
            tabItem("vote_tab", div(p("Dashboard tab content"))),
            tabItem("sido_vote", "시도 득표"),
            tabItem("sigungu_vote", "시군구 득표"),
            tabItem("map", "지도"),
            tabItem("sub_map", "지도 상위메뉴"),
            tabItem("sido_map", "시도 지도"),
            tabItem("sigungu_map", "시군구 지도")
        )
    )
)

server <- function(input, output) {
    

}

shinyApp(ui, server)
