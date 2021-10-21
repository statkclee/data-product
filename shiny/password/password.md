---
  title: "Old Faithful Eruptions"
output: 
  flexdashboard::flex_dashboard:
  css: styles-auth.css
runtime: shiny
---

  


Column {.sidebar}
-----------------------------------------------------------------------
  
Waiting time between eruptions and the duration of the eruption for the
Old Faithful geyser in Yellowstone National Park, Wyoming, USA.


```r
selectInput("n_breaks", label = "Number of bins:",
            choices = c(10, 20, 35, 50), selected = 20)
```

<!--html_preserve--><div class="form-group shiny-input-container">
<label class="control-label" for="n_breaks">Number of bins:</label>
<div>
<select id="n_breaks"><option value="10">10</option>
<option value="20" selected>20</option>
<option value="35">35</option>
<option value="50">50</option></select>
<script type="application/json" data-for="n_breaks" data-nonempty="">{}</script>
</div>
</div><!--/html_preserve-->

```r
sliderInput("bw_adjust", label = "Bandwidth adjustment:",
            min = 0.2, max = 2, value = 1, step = 0.2)
```

<!--html_preserve--><div class="form-group shiny-input-container">
<label class="control-label" for="bw_adjust">Bandwidth adjustment:</label>
<input class="js-range-slider" id="bw_adjust" data-min="0.2" data-max="2" data-from="1" data-step="0.2" data-grid="true" data-grid-num="9" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
</div><!--/html_preserve-->

Column
-----------------------------------------------------------------------
  
  ### Geyser Eruption Duration
  
  
  ```r
  renderPlot({
  hist(faithful$eruptions, probability = TRUE, breaks = as.numeric(input$n_breaks),
       xlab = "Duration (minutes)", main = "Geyser Eruption Duration")
  
  dens <- density(faithful$eruptions, adjust = input$bw_adjust)
  lines(dens, col = "blue")
  })
  ```
  
  <!--html_preserve--><div id="outa8e28b0725bbff9e" class="shiny-plot-output" style="width: 100% ; height: 400px"></div><!--/html_preserve-->
  
  ```r
  auth_ui(id = "auth")
  ```
  
  <!--html_preserve--><!--SHINY.SINGLETON[3e5b1de5abeacc96356afe42b14472ae3f00168c]-->
  <!--/SHINY.SINGLETON[3e5b1de5abeacc96356afe42b14472ae3f00168c]-->
  <div id="auth-auth-mod" class="panel-auth">
  <br/>
  <div style="height: 70px;"></div>
  <br/>
  <div class="row">
  <div class="col-sm-4 offset-md-4 col-sm-offset-4">
  <div class="panel panel-primary">
  <div class="panel-body">
  <div style="display:none">
  <div class="row">
  <div class="col-sm-4 offset-md-4 col-sm-offset-4">
  <div id="auth-label_language" class="shiny-html-output"></div>
  </div>
  <div class="col-sm-4">
  <div style="text-align: left; font-size: 12px;">
  <div class="form-group shiny-input-container" style="width: 100%;">
  <label class="control-label shiny-label-null" for="auth-language"></label>
  <div>
  <select id="auth-language"><option value="en" selected>English</option></select>
  <script type="application/json" data-for="auth-language" data-nonempty="">{}</script>
  </div>
  </div>
  </div>
  </div>
  </div>
  </div>
  <div style="text-align: center;">
  <h3 id="auth-shinymanager-auth-head">Please authenticate</h3>
  </div>
  <br/>
  <div class="form-group shiny-input-container" style="width: 100%;">
  <label class="control-label" for="auth-user_id">Username :</label>
  <input id="auth-user_id" type="text" class="form-control" value=""/>
  </div>
  <div class="form-group shiny-input-container" style="width: 100%;">
  <label class="control-label" for="auth-user_pwd">Password :</label>
  <input id="auth-user_pwd" type="password" class="form-control" value=""/>
  </div>
  <br/>
  <button class="btn btn-default action-button btn-primary" id="auth-go_auth" style="width: 100%;" type="button">Login</button>
  <br/>
  <br/>
  <script>bindEnter('auth-');</script>
  <div id="auth-result_auth"></div>
  <div id="auth-update_shinymanager_language" class="shiny-html-output"></div>
  </div>
  </div>
  </div>
  </div>
  </div><!--/html_preserve-->
  
  ```r
  auth <- callModule(
  module = auth_server,
  id = "auth",
  check_credentials = check_credentials(credentials) # data.frame
  # check_credentials = check_credentials("path/to/credentials.sqlite", passphrase = "supersecret") # sqlite
  )
  ```
  
  ```
  ## Error in callModule(module = auth_server, id = "auth", check_credentials = check_credentials(credentials)): session must be a ShinySession or session_proxy object.
  ```
