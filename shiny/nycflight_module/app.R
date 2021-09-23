library(shiny)
library(tidyverse)

source(glue::glue("{here::here()}/shiny/nycflight_module/module.R"), encoding = "UTF-8")

# 데이터 ----

ua_data <-
  nycflights13::flights %>%
  filter(carrier == "UA") %>%
  mutate(ind_arr_delay = (arr_delay > 5)) %>%
  group_by(year, month, day) %>%
  summarize(
    n = n(),
    across(ends_with("delay"), mean, na.rm = TRUE)
  ) %>%
  ungroup()

# 함수 ----

viz_monthly <- function(df, y_var, threshhold = NULL) {
  
  ggplot(df) +
    aes(
      x = .data[["day"]],
      y = .data[[y_var]]
    ) +
    geom_line() +
    geom_hline(yintercept = threshhold, color = "red", linetype = 2) +
    scale_x_continuous(breaks = seq(1, 29, by = 7)) +
    theme_minimal()
}

# Shiny UI -------------

ui <- fluidPage(
  
  titlePanel("비행기 연착 보고서"),
  
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput("month", "월간 보고서", 
                  choices = setNames(1:12, glue::glue("{1:12} 월")),
                  selected = 1
      )
    ),
    
    mainPanel = mainPanel(
      h2(textOutput("title")),
      h3("평균 도착 연착 시간"),
      h4("단위: 분"),
      plot_ui("arr_delay")
    )
  )
)

# Shiny Server -------------

server <- function(input, output, session) {
  
  output$title <- renderText({glue::glue("{input$month} 월 보고서")})
  
  df_month <- reactive({
    ua_data %>% 
      filter(month == input$month)
  })
  
  plot_server("arr_delay", df_month, y_var = "arr_delay", threshhold = 10)
  
}

shinyApp(ui, server)
