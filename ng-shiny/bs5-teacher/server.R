
library(shiny)

function(input, output) {
  
  # 1. 데이터 선정 ---------------------------------
  hs_dataset <- reactive(
    get(input$hs_dataset_input, asNamespace('hsData'))
  )
  
  ## 1.1. 데이터 살펴보기: gt ---------------------------------
  output$teacher_gt <- render_gt({
    
    hs_dataset() %>% 
      gt()
  })
  
  ## 1.2. 데이터 상세 ---------------------------------
  output$teacher_dataset_details <- renderPrint({
    
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
  output$teacher_summary <- renderPrint({
    
    hs_dataset() %>% 
      skimr::skim()
    
  })  

  # 3. 시각화 ---------------------------------
  ## 3.1. 숫자형 ------------------------------
  output$num_plot <- renderPlot({
    

    hs_dataset() %>% 
      select_if(is.numeric) %>% 
      ggpairs() + 
        theme_bw()
    
  })
  
  ## 3.2. 범주형 ------------------------------
  output$cat_plot <- renderPlot({
    
    plot_dataset <- hs_dataset() %>% 
      select_if(is.factor)
    
    if(ncol(plot_dataset) == 0) {
      return(NULL)
    } else {
      plot_dataset %>% 
        ggpairs() + 
          theme_bw()
    }
    
  })
  
}

