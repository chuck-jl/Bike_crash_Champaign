vars <- c(
  "Bike crash Heatmap" = "heatmap",
  "Bike crash and bike trails" = "trails",
  "Bike crash and bike turnings" = "turning"
)

vars1 <- c(
  "Reset" = "reset",
  "Champaign" = "champaign",
  "Urbana" = "urbana")

navbarPage("Bike Crashes Analysis in Champaign County",
           tabPanel("Interactive Map",div(class="outer",
                                         
                                         tags$head(
                                           # Include our custom CSS
                                           includeCSS("styles.css"),
                                           includeScript("gomap.js")
                                         ),
                                         leafletOutput("map", width="100%", height="100%"),
                                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                                       draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                                       width = 450, height = "auto",
                                                       
                                                       h2("Explore the Bike Crashes in Champaign"),
                                                       
                                                       selectInput("select", "Explore", vars),
                                                       selectInput("zoom", "Cities", vars1),
                                                       br(),
                                                       highchartOutput("crashes")
      
                                         ),
                                         tags$div(id="cite",
                                                  'Data compiled from ', tags$em('UUATS Open data Portal'), ' by Jiangdong Liu in 2016.'
                                         )
           )),
           tabPanel("Raw Data",
                    
             tabPanel("Bike crashes",
                      numericInput("maxrows", "Rows to show", 25, min=1, max=1000),
                      verbatimTextOutput("bikecrash"),
                      downloadButton("downloadCsv", "Download All Data as CSV"))
            
             )
           )
           