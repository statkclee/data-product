library(gridlayout)
library(shiny)

grid_page(
  theme = bitStat_theme,
  layout = c(
    "header header header",
    "hs_dataset teacher_dataset teacher_details",
    "teacher_statistics teacher_viz_numeric teacher_viz_categorical",
    "footer footer footer"
  ),
  row_sizes = c(
    "90px",
    "1.4fr",
    "1.39fr",
    "0.21fr"
  ),
  col_sizes = c(
    "1fr",
    "1fr",
    "1fr"
  ),
  gap_size = "13px",
  grid_card_text(
    area = "header",
    content = "고교 오픈 통계 - 교육용",
    h_align = "start",
    alignment = "center",
    is_title = TRUE
  ),
  grid_card(
    area = "hs_dataset",
    title = "hsData 데이터셋",
    item_gap = "15px",
    selectInput(
      inputId = "hs_dataset_input",
      label = "hsData 패키지 내장 데이터",
      choices = setNames(
        hsData_df$Item,
        hsData_df$Title
      )
    )
  ),
  grid_card(
    area = "teacher_dataset",
    title = "데이터셋",
    scrollable = TRUE,
    item_gap = "15px",
    gt_output("teacher_gt")
  ),
  grid_card(
    area = "teacher_statistics",
    title = "요약통계량",
    item_gap = "15px",
    verbatimTextOutput(
      outputId = "teacher_summary",
      placeholder = TRUE
    )
  ),
  grid_card(
    area = "teacher_details",
    title = "데이터 상세정보",
    scrollable = TRUE,
    item_gap = "15px",
    uiOutput(outputId = "teacher_dataset_details")
  ),
  grid_card(
    area = "teacher_viz_numeric",
    title = "시각화 (숫자형)",
    item_gap = "15px",
    plotOutput(
      outputId = "num_plot",
      width = "100%",
      height = "400px"
    )
  ),
  grid_card(
    area = "teacher_viz_categorical",
    title = "시각화 (범주형)",
    item_gap = "15px",
    plotOutput(
      outputId = "cat_plot",
      width = "100%",
      height = "400px"
    )
  ),
  grid_card_text(
    area = "footer",
    content = "제작: 한국 R 사용자회",
    alignment = "center"
  )
)

