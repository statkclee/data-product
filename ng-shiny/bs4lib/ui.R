library(gridlayout)
library(shiny)
library(bslib)

bitStat_theme = bs_theme(
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
  # Can also add lower-level customization
  "input-border-color" = "#EA80FC"
)


grid_page(
  theme = bitStat_theme,
  layout = c(
    "header header header header",
    "middle_school_row ms_first ms_second ms_third",
    "high_school_row hs_first hs_second hs_third",
    ". footer footer footer"
  ),
  row_sizes = c(
    "100px",
    "1.3fr",
    "1.3fr",
    "0.4fr"
  ),
  col_sizes = c(
    "115px",
    "1fr",
    "1fr",
    "1fr"
  ),
  gap_size = "15px",
  grid_card_text(
    area = "header",
    content = "고교 오픈 통계",
    h_align = "start",
    alignment = "center",
    is_title = TRUE
  ),
  grid_card(
    area = "ms_first",
    item_gap = "15px",
    title = "중학교 1학년",
    alignment = "center",
    uiOutput("ms_textbook_01")
  ),
  grid_card(
    area = "ms_second",
    item_gap = "15px",
    title = "중학교 2학년",
    alignment = "center",
    uiOutput(outputId = "ms_textbook_02")
  ),
  grid_card(
    area = "ms_third",
    item_gap = "15px",
    title = "중학교 3학년",
    alignment = "center",
    uiOutput(outputId = "ms_textbook_03")
  ),
  grid_card(
    area = "hs_first",
    item_gap = "15px",
    title = "고등학교 1학년",
    alignment = "center",
    uiOutput(outputId = "hs_textbook_01")
  ),
  grid_card(
    area = "hs_second",
    item_gap = "15px",
    title = "고등학교 2학년",
    alignment = "center",
    uiOutput(outputId = "hs_textbook_02")
  ),
  grid_card(
    area = "hs_third",
    item_gap = "15px",
    title = "고등학교 3학년",
    alignment = "center",
    uiOutput(outputId = "hs_textbook_03")
  ),
  grid_card_text(
    area = "footer",
    content = "제작: 한국 R 사용자회",
    alignment = "center"
  ),
  grid_card_text(
    area = "middle_school_row",
    content = "중등",
    alignment = "center"
  ),
  grid_card_text(
    area = "high_school_row",
    content = "고등",
    alignment = "center"
  )
)
