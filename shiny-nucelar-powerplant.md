# 데이터 제품




## 1. 원자력 발전소 현황 {#nuclear-power-plant}

북한 원자폭탄/수소폭탄 실험 소식과 함께, 대한민국 원자력 발전소에 관심도 점점 높아지고 있다.
[한국 원자력산업회의(KAIF)](http://www.kaif.or.kr)에서 국내 원전 현황에 대한 정보를 제공하고 있다.
이를 바탕으로 국내 원전 현황에 대한 데이터분석을 진행해 보자.

<img src="fig/nuclear-powerplant-data-analysis.png" alt="원자력 발전소 데이터 분석 개요" width="77%" />

## 2. 데이터 분석 개요 {#data-analysis-overview}

한국 원자력 산업협회 [국내 원전 현황](http://www.kaif.or.kr/?c=dat&s=6) 웹사이트에서 데이터를 긁어와서 
이를 데이터프레임으로 가공하고 나서 `ggplot`을 시각화하고, 더 나아가 `shiny`를 활용하여 웹앱을 개발하여 가시성을 확보한다.

### 2.1. 데이터 준비 {#crawl-data}

가장 먼저 원전 위치 시각화를 위해 원전위치 정보를 준비한다.
[원전위치](https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=8&cad=rja&uact=8&ved=0ahUKEwjTyredvpTWAhUHULwKHehgANoQFghbMAc&url=https%3A%2F%2Fwww.google.com%2Fmymaps%2Fviewer%3Fmid%3D1R4drSpsriaDZ6WxYPaa1ENr4KVQ%26hl%3Den_US&usg=AFQjCNEqxQfofwYY1NffYmrA3H5BB93H0g) 
구글 정보를 활용하였다.

그리고 나서, 총 24기에 대한 고리, 월성, 한빛, 한울 원전에 대한 세부 정보를 `rvest` 팩키지를 통해 가져온다.
그리고, 긁어온 데이터에 전처리 작업을 통해 상업운전일은 날짜형으로 콤마가 들어있는 발전량 정보는 숫자형으로, 
마지막으로 시각화를 원활히 할 수 있도록 일부 문자형 변수에 대한 데이터 정제작업도 병행하여 수행한다.


~~~{.r}
# 0. 환경설정 ------------------------------------

# library(tidyverse)
# library(rvest)
# library(stringr)
# library(hrbrthemes)
# library(extrafont)
# loadfonts()

# 1. 데이터 가져오기 -----------------------------
## 1.1. 원전 주소 --------------------------------

npp_addr_df <- tribble(~name, ~address, ~lat, ~lon,
                       "고리", "부산광역시 기장군 장안읍 고리", 35.459936176050455, 129.31042595766428,
                       "월성", "경상북도 경주시 양남면 나아리", 35.61415131635102, 129.47316094301584,
                       "한빛", "전라남도 영광군 홍농읍 계마리", 35.51221255154207, 126.578604835085,
                       "한울", "경상북도 울진군 북면 부구리", 37.18011679577809, 129.16451181750688)

# saveRDS(npp_addr_df, "shinyapp/npp/npp_addr_df.rds")

## 1.2. 원전별 정보 --------------------------------
Sys.setlocale("LC_ALL", "C")
~~~



~~~{.output}
[1] "C"

~~~



~~~{.r}
url <- "http://www.kaif.or.kr/?c=dat&s=6"

pusan_npp_df <- url %>% 
    read_html() %>% 
    html_nodes(xpath='//*[@id="container"]/div[2]/div[1]/table[2]') %>% 
    html_table(fill=TRUE) %>% 
    .[[1]]
    
kyungju_npp_df <- url %>% 
    read_html() %>% 
    html_nodes(xpath='//*[@id="container"]/div[2]/div[1]/table[3]') %>% 
    html_table(fill=TRUE) %>% 
    .[[1]]

youngkwang_npp_df <- url %>% 
    read_html() %>% 
    html_nodes(xpath='//*[@id="container"]/div[2]/div[1]/table[4]') %>% 
    html_table(fill=TRUE) %>% 
    .[[1]]

wooljin_npp_df <- url %>% 
    read_html() %>% 
    html_nodes(xpath='//*[@id="container"]/div[2]/div[1]/table[5]') %>% 
    html_table(fill=TRUE) %>% 
    .[[1]]
Sys.setlocale("LC_ALL", "Korean")
~~~



~~~{.output}
[1] "LC_COLLATE=Korean_Korea.949;LC_CTYPE=Korean_Korea.949;LC_MONETARY=Korean_Korea.949;LC_NUMERIC=C;LC_TIME=Korean_Korea.949"

~~~



~~~{.r}
# 2. 데이터 정제 -----------------------------

names(pusan_npp_df) <- c("발전소명", "기명", "노형", "설비용량", "상업운전일", "발전량", "이용률", "가동률")
names(kyungju_npp_df) <- c("발전소명", "기명", "노형", "설비용량", "상업운전일", "발전량", "이용률", "가동률")
names(youngkwang_npp_df) <- c("발전소명", "기명", "노형", "설비용량", "상업운전일", "발전량", "이용률", "가동률")
names(wooljin_npp_df) <- c("발전소명", "기명", "노형", "설비용량", "상업운전일", "발전량", "이용률", "가동률")

npp_df <- bind_rows(pusan_npp_df, kyungju_npp_df) %>% 
    bind_rows(youngkwang_npp_df) %>% 
    bind_rows(wooljin_npp_df)

npp_cl_df <- npp_df %>% mutate(설비용량 = as.numeric(str_replace(설비용량, ",", "")),
                  발전량 = as.numeric(str_replace_all(발전량, ",", "")),
                  상업운전일 = str_replace_all(상업운전일, "\\.", "-"),
                  상업운전일 = str_replace_all(상업운전일, "\\`|\\’", ""), 
                  상업운전일 = str_replace_all(상업운전일, " ", "")) %>% 
    mutate(상업운전일 = lubridate::parse_date_time(상업운전일, "%y-%m-%d")) %>% 
    mutate(발전소지역 = case_when(
                              str_detect(발전소명, "고리") ~ "고리",
                              str_detect(발전소명, "월성") ~ "월성",
                              str_detect(발전소명, "한빛") ~ "한빛",
                              str_detect(발전소명, "한울") ~ "한울"))  %>% 
    mutate(시대 = paste(lubridate::year(상업운전일) %/% 10 * 10, "년대")) %>% 
    mutate(발전소기명 = str_c(발전소명, "_", 기명))

#saveRDS(npp_cl_df, "shinyapp/npp/npp_cl_df.rds")
DT::datatable(npp_cl_df) %>% 
    DT::formatDate("상업운전일", method = 'toLocaleDateString', params = list('ko-KR')) %>% 
    DT::formatRound("발전량", digits=0)
~~~

<!--html_preserve--><div id="htmlwidget-3e8fba6350228f02b72f" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-3e8fba6350228f02b72f">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25"],["고리","고리","고리","고리","신고리","신고리","신고리","월성","월성","월성","월성","신월성","신월성","한빛(구영광)","한빛(구영광)","한빛(구영광)","한빛(구영광)","한빛(구영광)","한빛(구영광)","한울(구울진)","한울(구울진)","한울(구울진)","한울(구울진)","한울(구울진)","한울(구울진)"],["#1","#2","#3","#4","#1","#2","#3","#1","#2","#3","#4","#1","#2","#1","#2","#3","#4","#5","#6","#1","#2","#3","#4","#5","#6"],["경수로","경수로","경수로","경수로","경수로","경수로","신형경수로","중수로","중수로","중수로","중수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로","경수로"],[587,650,950,950,1000,1000,1400,679,700,700,700,1000,1000,950,950,1000,1000,1000,1000,950,950,1000,1000,1000,1000],["1975-04-29T00:00:00Z","1983-07-25T00:00:00Z","1985-09-30T00:00:00Z","1986-04-29T00:00:00Z","2011-02-28T00:00:00Z","2012-07-20T00:00:00Z","2016-12-20T00:00:00Z","1983-04-22T00:00:00Z","1997-07-01T00:00:00Z","1998-07-01T00:00:00Z","1999-10-01T00:00:00Z","2012-07-31T00:00:00Z","2015-07-24T00:00:00Z","1986-08-25T00:00:00Z","1987-06-10T00:00:00Z","1995-03-31T00:00:00Z","1996-01-01T00:00:00Z","2002-05-21T00:00:00Z","2002-12-24T00:00:00Z","1988-09-10T00:00:00Z","1989-09-30T00:00:00Z","1998-08-11T00:00:00Z","1999-12-31T00:00:00Z","2004-07-29T00:00:00Z","2005-04-22T00:00:00Z"],[4771551,4002134,9178782,8052761,9163286,6975411,3047246,3208962,4382519,4204362,4491633,7799314,7632697,6671963,3072311,7334828,8942197,9187364,8013130,7192555,7710086,4858507,5612396,7246178,9243256],[89.5,66.9,100.2,87.8,99.6,75.9,102.4,53.3,74.4,70.9,75.8,84.7,82.9,73.4,34.1,79.8,99.6,99.2,86.8,81.2,86.6,52.7,60.7,78.4,100.2],[89.8,67.6,100,88.2,100,76.5,100,54.3,74.3,70.8,76.5,85.6,83.4,74.4,34,80.7,100,100,87.3,81.6,87.3,53.6,71.7,79.2,100],["고리","고리","고리","고리","고리","고리","고리","월성","월성","월성","월성","월성","월성","한빛","한빛","한빛","한빛","한빛","한빛","한울","한울","한울","한울","한울","한울"],["1970 년대","1980 년대","1980 년대","1980 년대","2010 년대","2010 년대","2010 년대","1980 년대","1990 년대","1990 년대","1990 년대","2010 년대","2010 년대","1980 년대","1980 년대","1990 년대","1990 년대","2000 년대","2000 년대","1980 년대","1980 년대","1990 년대","1990 년대","2000 년대","2000 년대"],["고리_#1","고리_#2","고리_#3","고리_#4","신고리_#1","신고리_#2","신고리_#3","월성_#1","월성_#2","월성_#3","월성_#4","신월성_#1","신월성_#2","한빛(구영광)_#1","한빛(구영광)_#2","한빛(구영광)_#3","한빛(구영광)_#4","한빛(구영광)_#5","한빛(구영광)_#6","한울(구울진)_#1","한울(구울진)_#2","한울(구울진)_#3","한울(구울진)_#4","한울(구울진)_#5","한울(구울진)_#6"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>발전소명<\/th>\n      <th>기명<\/th>\n      <th>노형<\/th>\n      <th>설비용량<\/th>\n      <th>상업운전일<\/th>\n      <th>발전량<\/th>\n      <th>이용률<\/th>\n      <th>가동률<\/th>\n      <th>발전소지역<\/th>\n      <th>시대<\/th>\n      <th>발전소기명<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"crosstalkOptions":{"key":null,"group":null},"columnDefs":[{"className":"dt-right","targets":[4,6,7,8]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"rowCallback":"function(row, data) {\nDTWidget.formatRound(this, row, data, 6, 0, 3, ',', '.');\nDTWidget.formatDate(this, row, data, 5, 'toLocaleDateString', [\"ko-KR\"]);\n}"},"selection":{"mode":"multiple","selected":null,"target":"row"}},"evals":["options.rowCallback"],"jsHooks":[]}</script><!--/html_preserve-->

### 2.3. 시각화 {#viz-data}

"가동률과 발전량", "발전소별 발전량", "발전소 설비용량", "이용률과 가동률"을 `ggplot`을 통해 시각화한다.
문제를 자주 야기하는 가동률이 떨어지는 일부 원전에 대한 정보를 비롯한 다양한 정보를 한눈에 확인이 가능하다.


~~~{.r}
# 3. 데이터 시각화 -----------------------------
## 3.1. 가동률과 발전량
npp_cl_df %>% ggplot(aes(x=가동률, y=발전량, color=노형)) +
    geom_point() +
    theme_ipsum(base_family = "NanumGothic") +
    facet_wrap(~시대, nrow=1) +
    theme(legend.position = "top") +
    scale_y_continuous(labels = scales::comma) +
    labs(x="가동률(%)", y="발전량",
         title="대한민국 원자력 발전소 시대별 가동률과 발전량",
         subtitle="발전량(Mwh), 2016년 기준")
~~~

<img src="fig/unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

~~~{.r}
## 3.2. 발전량
npp_cl_df %>% 
    ggplot(aes(x=reorder(발전소기명, 발전량), y=발전량, fill=노형)) +
    geom_bar(stat="identity") +
    theme_ipsum(base_family = "NanumGothic") +
    coord_flip() +
    theme(legend.position = "top") +
    scale_y_continuous(labels = scales::comma) +
    labs(x="", y="발전량",
         title="대한민국 원자력 발전소 발전량",
         subtitle="발전량(Mwh), 2016년 기준")
~~~

<img src="fig/unnamed-chunk-2-2.png" style="display: block; margin: auto;" />

~~~{.r}
## 3.3.설비용량
npp_cl_df %>% 
    ggplot(aes(x=reorder(발전소기명, 설비용량), y=설비용량, fill=노형)) +
    geom_bar(stat="identity") +
    theme_ipsum(base_family = "NanumGothic") +
    coord_flip() +
    theme(legend.position = "top") +
    scale_y_continuous(labels = scales::comma) +
    labs(x="", y="설비용량",
         title="대한민국 원자력 발전소 발전량",
         subtitle="발전량(Mwh), 2016년 기준")
~~~

<img src="fig/unnamed-chunk-2-3.png" style="display: block; margin: auto;" />

~~~{.r}
## 3.4.이용률 vs. 가동률

worst_npp <- npp_cl_df %>%
    filter(이용률 <=70)

npp_cl_df %>% 
    ggplot(aes(x=가동률, y=이용률, color=노형)) +
    geom_point(size=2) +
    theme_ipsum_rc(base_family = "NanumGothic") +
    coord_flip() +
    theme(legend.position = "top") +
    scale_y_continuous(labels = scales::comma) +
    labs(x="가동률(%)", y="이용률(%)",
         title="대한민국 원자력 발전소 발전량",
         subtitle="발전량(Mwh), 2016년 기준") +
    ggrepel::geom_label_repel(aes(label=발전소기명), data=worst_npp, family="NanumGothic")
~~~



~~~{.output}
Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
윈도우즈 폰트데이터베이스에서 찾을 수 없는 폰트페밀리입니다

Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
윈도우즈 폰트데이터베이스에서 찾을 수 없는 폰트페밀리입니다

Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
윈도우즈 폰트데이터베이스에서 찾을 수 없는 폰트페밀리입니다

~~~

<img src="fig/unnamed-chunk-2-4.png" style="display: block; margin: auto;" />

## 3. 원전 위치 시각화 {#map, message=FALSE, warning=FALSE}

`ggmap`을 활용하여 간단히 정정 공간정보를 시각화할 수 있고, `leaflet`을 활용하여 시각화하는 동적으로 시각화하는 것도 가능하다.


~~~{.r}
# 4. ggmap --------------------------------

south_korea <- get_map(location="South Korea", zoom=7, maptype='terrain', source='google', color='color')
~~~



~~~{.output}
Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=South+Korea&zoom=7&size=640x640&scale=2&maptype=terrain&language=en-EN&sensor=false

~~~



~~~{.output}
Information from URL : http://maps.googleapis.com/maps/api/geocode/json?address=South%20Korea&sensor=false

~~~



~~~{.r}
ggmap(south_korea) +
    geom_point(aes(x = lon, y = lat), data = npp_addr_df, colour = "red", size = 3)
~~~

<img src="fig/ggmap-leaflet-1.png" style="display: block; margin: auto;" />

~~~{.r}
library(leaflet)
leaflet(data = npp_addr_df) %>% addTiles() %>%
    addMarkers(~lon, ~lat, popup = ~as.character(name))
~~~

<!--html_preserve--><div id="htmlwidget-9c2e2ec7c4ed4ba35f10" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-9c2e2ec7c4ed4ba35f10">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[35.4599361760505,35.614151316351,35.5122125515421,37.1801167957781],[129.310425957664,129.473160943016,126.578604835085,129.164511817507],null,null,null,{"clickable":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},["고리","월성","한빛","한울"],null,null,null,null,null,null]}],"limits":{"lat":[35.4599361760505,37.1801167957781],"lng":[126.578604835085,129.473160943016]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## 4. shiny 웹앱 {#shiny}

### 4.1. UI 설계 {#shiny-prototype}

데이터 분석한 결과를 단순히 보고서로 제출하는 것이 아닌 인터랙티브한 웹앱으로 개발할 경우,
[Shiny](http://shiny.rstudio.com/)를 활용하는 것도 좋은 접근법이 된다. 그 전에 먼저 
UI를 설계해야 하는데 GNU 라이선스를 따르는 [Pencil: Multiplatform GUI Prototyping/Wireframing](https://github.com/prikhi/pencil/releases)을 활용하는 것도 좋은 접근법이 된다.

<img src="fig/shiny-pencil.png" alt="원자력 발전소 Shiny 웹앱" width="77%" />

### 4.2. server, ui 코딩 {#shiny-server-ui}

#### 4.2.1. `ui.R` {#shiny-ui}

`ui.R` 에 `radioButtons`과 `checkboxInput`을 지정하여 원전 위치와 앞서 개발한 `ggplot`을 클릭할 경우 화면에 
표현되도록 UI를 설정한다.


~~~{.r}
fluidPage(
    titlePanel("South Korea Nuclear Power Plant(원자력 발전소)"),
    
    sidebarPanel(
        radioButtons("npp_menu", "그래프 선택:",
                     choiceNames = list(
                         "가동률과 발전량",
                         "발전소별 발전량",
                         "발전소 설비용량",
                         "이용률과 가동률"
                     ),
                     choiceValues = list(
                         "가동률과 발전량",
                         "발전소별 발전량",
                         "발전소 설비용량",
                         "이용률과 가동률"
                     )),
        checkboxInput("npp_map", "원전 위치", FALSE)
    ),
    
    mainPanel(
        textOutput("txt"),
        plotOutput('plot'),
        leafletOutput("map")
    )
)
~~~

#### 4.2.2. `server.R` {#shiny-server}

라디오 버튼이 클릭되면 해당 ggplot 그래프가 화면에 출력되도록 구현한다.
마찬가지로 체크박스가 클릭되면 원전위치가 나타나도록 기능을 구현한다.


~~~{.r}
library(shiny)
library(ggplot2)
library(leaflet)

npp_cl_df <- readRDS("npp_cl_df.rds")
npp_addr_df <- readRDS("npp_addr_df.rds")

server <- function(input, output) {

    output$txt <- renderText({
        if(input$npp_menu == "가동률과 발전량") {
            paste(input$npp_menu, " - 데이터 출처: http://www.kaif.or.kr/?c=dat&s=6")
        } else if(input$npp_menu == "발전소별 발전량") {
            paste(input$npp_menu, " - 데이터 출처: http://www.kaif.or.kr/?c=dat&s=6")
        } else if(input$npp_menu == "발전소 설비용량") {
            paste(input$npp_menu, " - 데이터 출처: http://www.kaif.or.kr/?c=dat&s=6")
        } else if(input$npp_menu == "이용률과 가동률") {
            paste(input$npp_menu, " - 데이터 출처: http://www.kaif.or.kr/?c=dat&s=6")
        } else {
            paste("데이터 출처: http://www.kaif.or.kr/?c=dat&s=6")
        }
    })
    
    output$plot <- renderPlot({
        
        if(input$npp_menu == "가동률과 발전량") {
            npp_cl_df %>% ggplot(aes(x=가동률, y=발전량, color=노형)) +
                geom_point() +
                theme_ipsum(base_family = "NanumGothic") +
                facet_wrap(~시대, nrow=1) +
                theme(legend.position = "top") +
                scale_y_continuous(labels = scales::comma) +
                labs(x="가동률(%)", y="발전량",
                     title="대한민국 원자력 발전소 시대별 가동률과 발전량",
                     subtitle="발전량(Mwh), 2016년 기준")
            
        } else if(input$npp_menu == "발전소별 발전량") {
            npp_cl_df %>% ggplot(aes(x=가동률, y=발전량, color=노형)) +
                geom_point() +
                theme_ipsum(base_family = "NanumGothic") +
                facet_wrap(~시대, nrow=1) +
                theme(legend.position = "top") +
                scale_y_continuous(labels = scales::comma) +
                labs(x="가동률(%)", y="발전량",
                     title="대한민국 원자력 발전소 시대별 가동률과 발전량",
                     subtitle="발전량(Mwh), 2016년 기준")
        } else if(input$npp_menu == "발전소 설비용량") {
            npp_cl_df %>% 
                ggplot(aes(x=reorder(발전소기명, 설비용량), y=설비용량, fill=노형)) +
                geom_bar(stat="identity") +
                theme_ipsum(base_family = "NanumGothic") +
                coord_flip() +
                theme(legend.position = "top") +
                scale_y_continuous(labels = scales::comma) +
                labs(x="", y="설비용량",
                     title="대한민국 원자력 발전소 발전량",
                     subtitle="발전량(Mwh), 2016년 기준")
        } else if(input$npp_menu == "이용률과 가동률") {
            worst_npp <- npp_cl_df %>%
                filter(이용률 <=70)
            
            npp_cl_df %>% 
                ggplot(aes(x=가동률, y=이용률, color=노형)) +
                geom_point(size=2) +
                theme_ipsum_rc(base_family = "NanumGothic") +
                coord_flip() +
                theme(legend.position = "top") +
                scale_y_continuous(labels = scales::comma) +
                labs(x="가동률(%)", y="이용률(%)",
                     title="대한민국 원자력 발전소 발전량",
                     subtitle="발전량(Mwh), 2016년 기준") +
                ggrepel::geom_label_repel(aes(label=발전소기명), data=worst_npp, family="NanumGothic")
        } else {
            stop("...")
        }
    })
    
    output$map <- renderLeaflet({
        if(input$npp_map){
            leaflet(data = npp_addr_df) %>% addTiles() %>%
                addMarkers(~lon, ~lat, popup = ~as.character(name))
        }
    })
}
~~~

<img src="fig/shiny-app-nuclear-powerplant.png" alt="원자력 발전소 Shiny App" width= "77%" />
