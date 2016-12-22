library(leaflet)
library(scales)
library(htmlwidgets)
library(sp)
library(maptools)
library(rgdal)
library(leaflet.extras)
library(highcharter)

Bike_Crashes <- readOGR(dsn = "./bike_crashes.shp", layer = "bike_crashes")
Turning <- readOGR(dsn = "./trail1.shp", layer = "trail1")
Bike_Trails <- readOGR(dsn = "./trails_and_bikeways.shp", layer = "trails_and_bikeways")
Daylight <- c("Daylight")
Othertime <- c("Darkness", "Darkness, lighted road", "Dawn", "Dusk", "NA")
Bike_Crashes.Daylight <- Bike_Crashes[Bike_Crashes$light %in% Daylight,] 
Bike_Crashes.Othertime <- Bike_Crashes[Bike_Crashes$light %in% Othertime,]

Daylight.popup <- paste0("<b>Year: </b>", Bike_Crashes.Daylight@data$year, "<br>",
                         "<b>Injury: </b>", Bike_Crashes.Daylight@data$injury, 
                         "<b>Fatality: </b>", Bike_Crashes.Daylight@data$fatality, "<br>",
                         "<b>Weather: </b>", Bike_Crashes.Daylight@data$weather, "<br>",
                         "<b>Road Surface: </b>", Bike_Crashes.Daylight@data$roadSurfac, "<br>",
                         "<b>Traffic Control:  </b>", Bike_Crashes.Daylight@data$trafficcon)


Othertime.popup <- paste0("<b>Year: </b>", Bike_Crashes.Othertime@data$year, "<br>",
                          "<b>Injury: </b>", Bike_Crashes.Othertime@data$injury, 
                          "<b>Fatality: </b>", Bike_Crashes.Othertime@data$fatality, "<br>",
                          "<b>Weather: </b>", Bike_Crashes.Othertime@data$weather, "<br>",
                          "<b>Road Surface: </b>", Bike_Crashes.Othertime@data$roadSurfac, "<br>",
                          "<b>Traffic Control:  </b>", Bike_Crashes.Othertime@data$trafficcon)

crash.popup <- paste0("<b>Year: </b>", Bike_Crashes@data$year, "<br>",
                      "<b>Injury: </b>", Bike_Crashes@data$injury, 
                      "<b>Fatality: </b>", Bike_Crashes@data$fatality, "<br>",
                      "<b>Weather: </b>", Bike_Crashes@data$weather, "<br>",
                      "<b>Road Surface: </b>", Bike_Crashes@data$roadSurfac, "<br>",
                      "<b>Traffic Control:  </b>", Bike_Crashes@data$trafficcon)
bike_crashes2 <- read.csv("./bike_crashes2.csv", row.names=NULL)
Rawdatacrash <- read.csv("./Rawdatacrash.csv")
TotalBikeCrashes <- read.csv("./TotalBikeCrashes.csv")