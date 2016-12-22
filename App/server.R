library(shiny)
library(shinydashboard)
library(highcharter)

function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(-88.222778, 40.120, zoom = 14) %>% 
      addWebGLHeatmap(lng=bike_crashes2$Latitude, lat=bike_crashes2$Name, size = 400, layerId = 'a')
  })
  
  output$crashes<-renderHighchart({
    highchart() %>% 
      hc_chart(type="column") %>% 
      hc_plotOptions(column = list(
        dataLabels = list(enabled = FALSE),
        stacking = "present",
        enableMouseTracking = FALSE)
      ) %>%
      hc_xAxis(categories = unique(TotalBikeCrashes$Year),
               tickmarkPlacement = 'on') %>% 
      hc_yAxis(title = list(text = "Crashes")) %>% 
      hc_add_series(data=TotalBikeCrashes$City.of.Champaign, name = "Crash in Champaign", color="orange") %>%
      hc_add_series(data=TotalBikeCrashes$City.of.Urbana, name = "Crash in Urbana", color = "dodgerblue") %>%
      hc_add_series(data=TotalBikeCrashes$Champaign.Urbana.Urbanized.Area, name = "Crash in Urbanized Areas", color="green") %>%
      hc_add_theme(hc_theme_gridlight())
    })
  
  
  output$downloadCsv <- downloadHandler(
    filename = "crashes.csv",
    content = function(file) {
      write.csv(Rawdatacrash, file)
    },
    contentType = "text/csv"
  )
  output$bikecrash <- renderPrint({
    orig <- options(width = 1000)
    print((tail(Rawdatacrash, input$maxrows)),row.names=FALSE)
    options(orig)
  })
  
  observe({
    selectBy <- input$select
    zoomBy <- input$zoom
    
    if (selectBy == "heatmap") {
      leafletProxy("map") %>%
        clearShapes() %>%
        removeWebGLHeatmap(layerId = 'a')%>%
        addWebGLHeatmap(lng=bike_crashes2$Latitude, lat=bike_crashes2$Name, size = 400, layerId = 'a')
    } else if (selectBy =="turning"){
      leafletProxy("map") %>%
        clearShapes() %>%
        removeWebGLHeatmap(layerId = 'a')%>%
      addCircles(data = Bike_Crashes, fillOpacity = 0.8, 
                 stroke = FALSE, weight = 5, radius = 20,
                 color = "cadetblue1",
                 popup=crash.popup,
                 group="crash"
      ) %>%
        addCircles(data = Turning, fillOpacity = 0.3, 
                   stroke = FALSE, weight = 5, radius = Turning@data$total_bike,
                   color = "salmon",
                   group="Turnings") %>%
        addLayersControl(
          overlayGroups = c("crash", "Turnings"),position='bottomright',
          options = layersControlOptions(collapsed = TRUE))
    } else {
      leafletProxy("map") %>%
        clearShapes() %>%
        removeWebGLHeatmap(layerId = 'a')%>%
        addCircles(data = Bike_Crashes.Daylight, fillOpacity = 0.5, 
                   stroke = FALSE, weight = 5, radius = 40,
                   color = "cadetblue1",
                   popup=Daylight.popup,
                   group="Daylight Incidents"
        ) %>%
        addCircles(data = Bike_Crashes.Othertime, fillOpacity = 0.5, 
                   stroke = TRUE, weight = 5, radius = 40,
                   color = "salmon",
                   popup=Othertime.popup,
                   group="Othertime Incidents"
        ) %>%
        addPolylines(data = Bike_Trails, fill = FALSE, stroke = TRUE , weight = 4, opacity = 0.3, 
                     fillOpacity = 0.8, dashArray = NULL, smoothFactor = 1, noClip = FALSE, group = "Bike Trail" )%>%
        addLayersControl(
          overlayGroups = c("Othertime Incidents", "Daylight Incidents", "Bike Trail"),position='bottomright',
          options = layersControlOptions(collapsed = TRUE))
    }
    
    if (zoomBy == "reset") {
      leafletProxy("map") %>%
        setView(-88.222778, 40.110, zoom = 14)}
    else if(zoomBy =="champaign") {
      leafletProxy("map") %>%
        setView(-88.252778, 40.110, zoom = 15)
    } else {
      leafletProxy("map") %>%
        setView(-88.200778, 40.110, zoom = 15)
    }
    
  })
  
}