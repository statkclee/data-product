


server <- function(input, output) {
  
  # 0. 변수명 선택 UI -------------------
  output$bucketlist <- renderUI({
    bucket_list(
      header = "변수를 한개 선택해서 옮기세요",
      group_name = "bucket_list_group",
      orientation = "horizontal",
      add_rank_list(
        text = "데이터셋 변수들",
        labels = names(hs_dataset()),
        input_id = "all_variables"
      ),
      add_rank_list(
        text = "분석 변수",
        labels = NULL,
        input_id = "target_variable"
      )
    )
  })
  
  # 1. 데이터 선정 ---------------------------------
  hs_dataset <- reactive(
    get(input$hs_dataset_input, asNamespace('hsData'))
  )
  
  ## 1.1. 데이터 살펴보기: gt ---------------------------------
  output$student_gt <- render_gt({
    
    hs_dataset() %>% 
      gt()
  })  

  ## 1.2. 데이터 상세 ---------------------------------
  output$student_dataset_details <- renderPrint({
    
    static_help <- function(pkg, topic, out, links = tools::findHTMLlinks()) {
      pkgRdDB = tools:::fetchRdDB(file.path(find.package(pkg), 'help', pkg))
      force(links)
      tools::Rd2HTML(pkgRdDB[[topic]], out, package = pkg,
                     Links = links, no_links = is.null(links))
    }
    
    tmp <- tempfile()
    static_help("hsData", input$hs_dataset_input, tmp)
    out <- readLines(tmp)
    headfoot <- grep("body", out)
    cat(out[(headfoot[1] + 1):(headfoot[2] - 1)], sep = "\n")
  })
  
  # 2. 요약 통계량: skimr ---------------------------------
  output$student_descriptive <- renderPrint({
    
    hs_dataset() %>% 
      select(input$target_variable) %>% 
      summary()
  })  
  
  # 3. 시각화 ---------------------------------
  ## 3.1. 숫자형 ------------------------------
  output$num_plot <- renderPlot({
    
    plot_dataset <- hs_dataset() %>% 
      select(input$target_variable)
    
    if(length(which(sapply(plot_dataset, is.numeric))) == 0) {
      return(NULL)
    } else {
      plot_dataset %>% 
        select_if(is.numeric) %>% 
        ggpairs() + 
        theme_bw()
    }
    
  })

  ## 3.2. 범주형 ------------------------------
  output$cat_plot <- renderPlot({
    
    plot_dataset <- hs_dataset() %>% 
      select(input$target_variable)

    if(length(which(sapply(plot_dataset, is.factor))) == 0) {
      return(NULL)
    } else {
      plot_dataset %>% 
        select_if(is.factor) %>% 
        ggpairs() + 
          theme_bw()
    }
    
  })  
  
}

