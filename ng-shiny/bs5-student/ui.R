
# App template from the shinyuieditor
ui <- grid_page(
  
  theme = bitStat_theme,
  
  layout = c(
    "student_title student_title student_title student_title",
    "student_select student_dataset student_info student_variable",
    "student_statistics student_statistics student_num_viz student_cat_viz",
    "footer footer footer footer"
  ),
  row_sizes = c(
    "90px",
    "1.4fr",
    "1.4fr",
    "0.20fr"
  ),
  col_sizes = c(
    "0.5fr",
    "0.5fr",
    "1fr",
    "1fr"
  ),
  gap_size = "1rem",
  grid_card_text(
    area = "student_title",
    content = "고교 통계 - 학생",
    alignment = "center",
    is_title = TRUE
  ),
  grid_card(
    area = "student_select",
    title = "데이터셋",
    item_gap = "12px",
    selectInput(
      inputId = "hs_dataset_input",
      label = "hsData 패키지 내장 데이터",
      choices = setNames(
        hsData_df$Item,
        hsData_df$Title
      )
    ),
    scrollable = TRUE
  ),
  grid_card(
    area = "student_dataset",
    title = "데이터셋",
    item_gap = "12px",
    scrollable = TRUE,
    gt_output("student_gt")
  ),
  grid_card(
    area = "student_info",
    title = "상세정보",
    item_gap = "12px",
    scrollable = TRUE,    
    uiOutput(outputId = "student_dataset_details")
  ),
  grid_card(
    area = "student_variable",
    title = "변수 선택",
    item_gap = "12px",
    scrollable = TRUE,
    htmlOutput("bucketlist")
  ),
  grid_card(
    area = "student_statistics",
    title = "요약 통계량",
    item_gap = "12px",
    verbatimTextOutput(
      outputId = "student_descriptive",
      placeholder = TRUE
    )    
  ),
  grid_card(
    area = "student_num_viz",
    title = "시각화 (숫자형)",
    item_gap = "12px",
    plotOutput(
      outputId = "num_plot",
      width = "100%",
      height = "400px"
    )    
  ),
  grid_card(
    area = "student_cat_viz",
    title = "시각화 (범주형)",
    item_gap = "12px",
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


