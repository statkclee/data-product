library(gridlayout)
library(shiny)
library(tidyverse)
library(gt)
library(skimr)
library(GGally)
library(sortable)
library(bslib)
library(thematic)

# 외양 --------------------------
bitStat_theme = bs_theme(
  bootswatch = "cosmo",
  version = 5,
  # 한글 글꼴
  heading_font = font_google("Gowun Dodum"),
  base_font    = font_google("Nanum Myeongjo"),
  code_font    = font_google("Nanum Gothic Coding"),
  # heading_font = font_collection(font_google("Gowun Dodum"), font_google("Nanum Gothic"), "sans-serif"),
  # base_font    = font_collection(font_google("Nanum Myeongjo"), font_google("Noto Serif Korean"), "serif"),
  # code_font    = font_collection(font_google("Nanum Gothic Coding"), "monospace"),
  # Controls the default grayscale palette
  # bg = "#202123", fg = "#B8BCC2",
  # Controls the accent (e.g., hyperlink, button, etc) colors
  primary = "#EA80FC", secondary = "#48DAC6",
  # 입력 상자 테두리 색상
  "input-border-color" = "#202123",
  "input-focus-border-color" = "#202123"
) 


# 데이터 ----------------------
hsData_list <- data(package = "hsData")

hsData_df <- hsData_list$results %>% 
  as_tibble() %>% 
  select(Item, Title)

