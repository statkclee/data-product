---
layout: page
title: 데이터 제품
subtitle: Shiny 데이터 제품 개발
output:
  html_document: 
    toc: yes
    toc_float: true
    highlight: tango
    code_folding: show
mainfont: NanumGothic
---


> ## 학습 목표 {.objectives}
>
> *  데이터 과학을 이해한다.
> *  Shiny 아키텍쳐를 설명한다.
> *  Shiny를 도구로 데이터 제품을 개발한다.

# 1. 데이터 과학 (Data Science) {#data-science}

자연법칙은 변수(Variable), 관측점(Observation), 값(Value)으로 구성된다. 
변수는 측정한 정량 혹은 정성적 특성이 되고, 
값은 측정한 시점에 변수의 상태이며, 관측점은 유사한 조건하에 측정한 여러 변수값 집합이다. 
자연법칙은 동일한 관측점 값에 적용되어 동작하는 변수를 다룬다. 
따라서, 자연법칙은 데이터에 **패턴(pattern)**으로 나타난다. 

변수, 관측점, 값으로 구성된 데이터를 가지고 있지만 현실 세계를 움직이는 자연법칙을 모른다면 패턴을 찾아서 자연법칙을 모사할 수 있고, 
현실 세계에 대한 자연법칙을 찾았다면 데이터를 통해서 확증하는 것도 가능하다.

<img src="fig/data-science-overview.png" alt="데이터 과학 개요" width="70%" />

## 1.1. 데이터 과학 프로세스 {#data-science-process}

[CRISP-DM(Cross-industry standard process for data mining)](https://en.wikipedia.org/wiki/Cross-industry_standard_process_for_data_mining)가 과거 유명한 
데이터 마이닝 모형이었다. [^crisp-dm-kor]

[^crisp-dm-kor]: [데이터 마이닝 방법론/프로세스 CRISP-DM](http://itlab.tistory.com/122)

- Business Understanding: 비즈니스 문제 인식 및 해결을 위한 데이터 마이닝 프로세스 명료화
- Data understanding: 데이터 탐색 및 이해
- Data prepation: 데이터를 통한 문제 인식 및 해결
- Modelding: 데이터 마이닝 기법 적용
- Evaluation: 비즈니스 상황에 따른 데이터 마이닝 결과의 해설
- Deployment: 데이터 마이닝 결과의 전개 및 유지

<img src="fig/data-science-process-as-is-to-be.png" alt="데이터 과학 프로세스 비교" width="50%" />

최근에 RStudio의 최고 데이터과학자 위캠 박사가 `tidyverse`을 통해 데이터과학을 새롭게 정의하고 있다.

> ### 데이터와 사투(Data Wrangling) {.callout}
>
> 데이터 먼징(Data Munging) 혹은 데이터 랭글링(Data Wrangling)은 원자료(raw data)를 또다른 형태로 수작업으로 
> 전환하거나 매핑하는 과정으로 데이터 원천(Data Source)에서 원래 최초 형태로 자료를 추출, 
> 알고리즘(예로, 정렬)을 사용해서 원자료를 "먼징(munging)"하거나 사전 정의된 자료구조로 데이터를 파싱(parsing)한다. 
> 마지막으로 저장이나 미래 사용을 위해 작업완료한 콘텐츠를 데이터 싱크(data sink)에 놓아두는 과정.
> 
> **데이터 랭글링(Data Wrangling)**
>     - 데이터 조작(Data Manipulation) : `dplyr`
>     - 데이터 깔끔화(Data Tidying) : `tidyr`
>     - 데이터 시각화(Data Visualization) : `ggplot`
>     - 모형(Modelling) : `broom`
>     - 데이터 프로그래밍(Data Programming) : `purrr`

## 1.2. Shiny 전시장(Showcase) [^shiny-showcase] {#shiny-showcase}

[D3](http://d3js.org/), [Leaflet](http://leafletjs.com/), [구글 챠트(Google Chart)](https://developers.google.com/chart/)같은 
자바스크립트 라이브러리를 함께 사용해서 다양한 Shiny 응용프로그램을 개발한 사례가 다음에 있다. 

[^shiny-showcase]: [Shiny User Showcase](http://www.rstudio.com/products/shiny/shiny-user-showcase/)


## 1.3. Shiny 응용프로그램 아키텍처 {#shiny-architecture}

Shiny 응용프로그램 개발 아키텍쳐는 R코드와 UI로 구성된다. 
데이터를 서버에서 처리하는 로직을 담고 있는 R코드(`server.r`)와 사용자 웹인터페이스를 담고 있고 있는 UI(`ui.r`)다. 

<img src="fig/shiny-app-architecture.png" alt="Shiny 응용프로그램 아키텍쳐" width="50%" />

## 1.4. Shiny 생태계 구성원 {#shiny-ecosystem}

`shiny`자체도 의미가 있지만 다양한 `shiny` 생태계 구성원도 꾸준히 개발되고 있다.

- [shinyBS](https://ebailey78.github.io/shinyBS/index.html): CSS Bootstrap 컴포넌트.
- [Shiny Themes](https://rstudio.github.io/shinythemes/): Shiny 테마 
- [shinydashboard](https://rstudio.github.io/shinydashboard/index.html): 대쉬보드 개발 목적
- [shinyjs](https://deanattali.com/shinyjs/): 자바스크립트 shiny 적용

## 3. Shiny 학습 목차 {#shiny-toc}

- [Shiny 웹앱](shiny-overview.html)
    - **`shiny` 1010**
        - [Shiny 웹앱 개발](shiny-app.html)    
        - [Shiny 반응형 웹앱 개발](shiny-reactive.html)    
        - [Shiny 프론트엔트 개발](shiny-frontend.html)
    - **shinydashboard 101**    
        - [주사위 던지기 - `shinydashbaord`](shiny-draw-dice.html)
        - [주사위 & 동전 던지기(UI) - `shinydashbaord`](shiny-die-coin.html)
    - **`shiny` 제품**    
        - [보안기능을 탑재한 Shiny 웹앱 서버 - AWS](shiny-webweb-server.html)
    - **딥러닝(Deep Learning)**
        - [이미지 분류 - 케라스(딥러닝)](shiny-image-classification.html)

> ### RStudio 웨비나 {.callout}
>
> RStudio 웨비나 *[How to start with Shiny–Part 1,2,3](http://www.rstudio.com/resources/webinars/)* 내용을 기반하여 작성되었습니다. 
> 웨비나 소스 및 발표자료는 [GitHub](https://github.com/rstudio/webinars)에서 `git clone`하여 이용가능합니다. 
> RStudio 웨비나 콘텐츠는 [CC-BY-NC](http://creativecommons.org/licenses/by-nc/3.0/us/)로 배포됩니다.

