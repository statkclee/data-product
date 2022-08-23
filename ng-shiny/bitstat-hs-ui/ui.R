library(gridlayout)

library(shiny)
library(hsData)
library(tidyverse)
library(gt)

hsData_list <- data(package = "hsData")

hsData_df <- hsData_list$results %>% 
  as_tibble() %>% 
  select(Item, Title)

grid_page(
  layout = c(
    "header header",
    "sidebar distPlot",
    ". viz_card"
  ),
  
  row_sizes = c(
    "100px",
    "1fr",
    "1fr"
  ),
  col_sizes = c(
    "250px",
    "1fr"
  ),
  
  gap_size = "1px",
  
  grid_card_text(
    area = "header",
    content = "고교 오픈 통계 패키지",
    alignment = "center",
    h_align = "start",
    is_title = TRUE
  ),
  
  grid_card(
    area = "sidebar",
    item_alignment = "top",
    title = "분석 데이터 설정",
    item_gap = "12px",
    selectInput(
      inputId = "hs_dataset_input",
      label = "hsData 패키지 내장 데이터",
      choices = setNames(hsData_df$Item, hsData_df$Title)
    )
  ),
  grid_card(
      "stockTable",
      gt_output("stockTable"), scrollable = TRUE
  ),
    
  grid_card_plot(area = "viz_card")
)

