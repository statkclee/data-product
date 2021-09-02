---
layout: page
title: xwMOOC 데이터 저널리즘
subtitle: 측정소 위치 - 대한민국
output:
  html_document: 
    toc: yes
    highlight: tango
    code_folding: hide
    css: css/swc.css
  pdf_document:
    latex_engine: xelatex
mainfont: NanumGothic
---
 


## 1. 공기 불평등 민주화 {#air-quality-inequality}

공기질이 삶의 질에 영향을 지대하게 미친다. 깨끗한 공기는 건강과 직결된다.
공기 불평등과 투쟁을 선언한 [OpenAQ(Open Air Quality)](https://openaq.org/) "2018-01-29" 기준 64개국에 설치된 8,254개 측정솔ㄹ 통해
155,673,930 공기품질 측정값을 수집하여 제공하고 있다.

## 2. 대한민국 측정소 현황 {#air-quality-inequality-korea-count}

공기질 측정소 현황은 한국환경공단 [Air Korea](https://www.airkorea.or.kr/) 홈페이지 **통계정보 &rarr; 대기환경 연월보**에서
대기환경 연보 최신 2016년 다운로드 받으면 구할 수 있다.
데이터가 깔끔(tidy)하지 않은 더러운(messy) 형태라 `tidyverse` 다양한 기능을 활용하여 정제작업을 거친다.


~~~{.r}
# 0. 환경설정 ------

library(tidyverse)
library(readxl)
library(purrr)
library(xts)
library(leaflet)
library(crosstalk)
library(DT)

# 1. 데이터 가져오기 -----
    
loc_dat <- read_excel("data/air_korea_2016/부록14.대기오염측정망 제원_170927.xls", sheet="2016년", skip=4)    

names(loc_dat) <- c("시도", "도시", "측정소코드", "측정소명", "주소", "longitude_DMS", "latitude_DMS", "비고")

# 2. 데이터 변환 -----

대기_df <- loc_dat %>% 
    filter(row_number() <= 281) %>% 
    mutate(측정기능 = "도시대기")

도로_df <- loc_dat %>% 
    filter(row_number() >= 287,
           row_number() <= 326) %>% 
    mutate(측정기능 = "도로변대기")

배경농도_df <- loc_dat %>% 
    filter(row_number() >= 330,
           row_number() <= 334) %>% 
    mutate(측정기능 = "국가배경농도")

교외대기_df <- loc_dat %>% 
    filter(row_number() >= 340,
           row_number() <= 358) %>% 
    mutate(측정기능 = "교외대기")

중금속_df <- loc_dat %>% 
    filter(row_number() >= 364,
           row_number() <= 421)  %>% 
    mutate(측정기능 = "대기중금속")

광화학_df <- loc_dat %>% 
    filter(row_number() >= 427,
           row_number() <= 446) %>% 
    mutate(측정기능 = "광화학오염")

유해물질_df <- loc_dat %>% 
    filter(row_number() >= 451,
           row_number() <= 483) %>% 
    mutate(측정기능 = "유해대기물질")

산성강하_df <- loc_dat %>% 
    filter(row_number() >= 489,
           row_number() <= 528) %>% 
    mutate(측정기능 = "산성강하물")

대기오염집중_df <- loc_dat %>% 
    filter(row_number() >= 534,
           row_number() <= 539) %>% 
    mutate(측정기능 = "대기오염집중")


PM25_df <- loc_dat %>% 
    filter(row_number() >= 545,
           row_number() <= 579) %>% 
    mutate(측정기능 = "PM25")

종합대기_df <- loc_dat %>% 
    filter(row_number() >= 585,
           row_number() <= 599) %>% 
    mutate(측정기능 = "종합대기")

# 3. 데이터 취합 -----

tmp <- mget(ls(pattern="_df"))

air_df <- map_df(tmp, bind_rows)

# 4. 데이터 정제 -----
air_df <- air_df %>% 
    filter(측정소명 != "측정소명",
           !is.na(측정소명))  %>% 
    mutate(시도 = na.locf(시도),
           도시 = na.locf(도시),
           측정소코드 = na.locf(측정소코드),
           측정소명 = na.locf(측정소명))
~~~


## 3. 측정 기능별 측정소 위치 시각화 {#air-quality-inequality-korea-leaflet}

총 12 개 기능을 갖는 다양한 공기품질 측정소가 전국에 산재하여 있다.
하지만, 측정소 위치가 도분초로 되어 있어 이를 도로 변환하는 과정을 거친다.

그리고 나서, `crosstalk` 기능을 추가하여 `leaflet`에서 공기품질 측정기능별로 측정소 위치를 파악할 수 있도록 작업한다.


~~~{.r}
# 1. 데이터 정제: 도분초 --> 도 변환 -----

air_df <- air_df %>% 
    tidyr::separate(longitude_DMS, into=c("경도_도", "경도_분", "경도_초"), sep=" ") %>%
    tidyr::separate(latitude_DMS, into=c("위도_도", "위도_분", "위도_초"), sep=" ") %>% 
    mutate(longitude = as.numeric(경도_도) + as.numeric(경도_분)/60 + as.numeric(경도_초)/3600) %>%
    mutate(latitude  = as.numeric(위도_도) + as.numeric(위도_분)/60 + as.numeric(위도_초)/3600)

# 2. 공간정보 시각화 -----
## 2.1. 공유 데이터

air_sd <- SharedData$new(air_df)

## 2.2. 제어
filter_checkbox("측정기능", "대기오염측정망 제원", air_sd, ~측정기능, inline = TRUE)
~~~

<!--html_preserve--><div id="측정기능" class="form-group crosstalk-input-checkboxgroup crosstalk-input">
<label class="control-label" for="측정기능">대기오염측정망 제원</label>
<div class="crosstalk-options-group">
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="PM25"/>
<span>PM25</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="광화학오염"/>
<span>광화학오염</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="교외대기"/>
<span>교외대기</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="국가배경농도"/>
<span>국가배경농도</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="대기중금속"/>
<span>대기중금속</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="도로변대기"/>
<span>도로변대기</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="도시대기"/>
<span>도시대기</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="산성강하물"/>
<span>산성강하물</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="유해대기물질"/>
<span>유해대기물질</span>
</label>
<label class="checkbox-inline">
<input type="checkbox" name="측정기능" value="종합대기"/>
<span>종합대기</span>
</label>
</div>
<script type="application/json" data-for="측정기능">{
  "map": {
    "PM25": ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"],
    "광화학오염": ["31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],
    "교외대기": ["51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69"],
    "국가배경농도": ["378", "379", "380"],
    "대기중금속": ["469", "470", "471", "472", "473", "474", "475", "476", "477", "478", "479", "480", "481", "482", "483", "484", "485", "486", "487", "488", "489", "490", "491", "492", "493", "494", "495", "496", "497", "498", "499", "500", "501", "502", "503", "504", "505", "506", "507", "508", "509", "510", "511", "512", "513", "514", "515", "516", "517", "518", "519", "520", "521", "522", "523", "524", "525"],
    "도로변대기": ["339", "340", "341", "342", "343", "344", "345", "346", "347", "348", "349", "350", "351", "352", "353", "354", "355", "356", "357", "358", "359", "360", "361", "362", "363", "364", "365", "366", "367", "368", "369", "370", "371", "372", "373", "374", "375", "376", "377"],
    "도시대기": ["70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "220", "221", "222", "223", "224", "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235", "236", "237", "238", "239", "240", "241", "242", "243", "244", "245", "246", "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257", "258", "259", "260", "261", "262", "263", "264", "265", "266", "267", "268", "269", "270", "271", "272", "273", "274", "275", "276", "277", "278", "279", "280", "281", "282", "283", "284", "285", "286", "287", "288", "289", "290", "291", "292", "293", "294", "295", "296", "297", "298", "299", "300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312", "313", "314", "315", "316", "317", "318", "319", "320", "321", "322", "323", "324", "325", "326", "327", "328", "329", "330", "331", "332", "333", "334", "335", "336", "337", "338"],
    "산성강하물": ["381", "382", "383", "384", "385", "386", "387", "388", "389", "390", "391", "392", "393", "394", "395", "396", "397", "398", "399", "400", "401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414", "415", "416", "417", "418", "419", "420"],
    "유해대기물질": ["421", "422", "423", "424", "425", "426", "427", "428", "429", "430", "431", "432", "433", "434", "435", "436", "437", "438", "439", "440", "441", "442", "443", "444", "445", "446", "447", "448", "449", "450", "451", "452", "453"],
    "종합대기": ["454", "455", "456", "457", "458", "459", "460", "461", "462", "463", "464", "465", "466", "467", "468"]
  },
  "group": ["SharedData391d7ffa"]
}</script>
</div><!--/html_preserve-->

~~~{.r}
## 2.3. 공간 정보 시각화
leaflet(data = air_sd) %>% 
    addProviderTiles(providers$OpenStreetMap) %>% 
    addMarkers(popup = ~ as.character(paste0("<strong>", paste0("측정소명: ", 측정소명), "</strong><br><br>",
                                             "-----------------------------------------------------------<br>",
                                             "&middot; 측정기능: ", 측정기능, "<br>",
                                             "&middot; 시도: ", 시도, "<br>",
                                             "&middot; 도시: ", 도시, "<br>",
                                             "&middot; 주소: ", 주소, "<br>"
               )))    
~~~

<img src="fig/airquality-location-korea-leaflet-1.png" title="plot of chunk airquality-location-korea-leaflet" alt="plot of chunk airquality-location-korea-leaflet" style="display: block; margin: auto;" />



## 3. 측정 기능별 측정소 위치 상세 {#air-quality-inequality-korea-table}

층정 기능별 측정소 상세정보를 표로 살펴보자.


~~~{.r}
air_df %>% 
    select(측정기능, 시도, 도시, 측정소코드, 측정소명, 주소, 비고, 
             경도=longitude, 위도=latitude) %>% 
    DT::datatable(filter = "top") %>% 
    formatCurrency(c("경도", "위도"), currency="", digits=6)
~~~

<img src="fig/airquality-location-korea-table-1.png" title="plot of chunk airquality-location-korea-table" alt="plot of chunk airquality-location-korea-table" style="display: block; margin: auto;" />
