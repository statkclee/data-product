library(gridlayout)
library(shiny)
library(tidyverse)
library(gt)
library(skimr)
library(GGally)

hsData_list <- data(package = "hsData")

hsData_df <- hsData_list$results %>% 
  as_tibble() %>% 
  select(Item, Title)

