library(spatstat)
library(here)
library(sp)
library(tmap)
library(sf)
library(tmaptools)
# Relative path using `here::here`
shapefile_path <- here::here("Statistical GIS Boundary Files for London", 
                             "statistical-gis-boundaries-london", 
                             "ESRI", 
                             "London_Borough_Excluding_HMN.shp")

# Read the shapefile
LondonBoroughs <- st_read(shapefile_path)

# Confirm it loaded correctly
head(LondonBoroughs)
library(sf)
library(here)

# Relative path using `here::here()`
shapefile_path <- here::here("Statistical GIS Boundary Files for London", 
                             "statistical-gis-boundaries-london", 
                             "ESRI", 
                             "London_Borough_Excluding_HMN.shp")

# Read the shapefile
LondonBoroughs <- st_read(shapefile_path)

# Confirm it loaded correctly
head(LondonBoroughs)
# List all files in the directory
list.files("C:/Users/z1782/OneDrive - University College London/Attachments/005/practical/05 practical/Statistical GIS Boundary Files for London/statistical-gis-boundaries-london/ESRI")
library(sf)

# Test absolute path
shapefile_path <- "C:/Users/z1782/OneDrive - University College London/Attachments/005/practical/05 practical/Statistical GIS Boundary Files for London/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_HMN.shp"
LondonBoroughs <- st_read(shapefile_path)

# Check if the data is loaded
head(LondonBoroughs)
library(sf)

# Correct full path (confirmed from list.files())
shapefile_path <- "C:/Users/z1782/OneDrive - University College London/Attachments/005/practical/05 practical/Statistical GIS Boundary Files for London/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_HMN.shp"

# Attempt to load the shapefile
LondonBoroughs <- st_read(shapefile_path)

# Check if data loaded correctly
head(LondonBoroughs)
library(sf)

# Correct file path with the proper file name
shapefile_path <- "C:/Users/z1782/OneDrive - University College London/Attachments/005/practical/05 practical/Statistical GIS Boundary Files for London/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp"

# Load the shapefile
LondonBoroughs <- st_read(shapefile_path)

# Confirm it loaded correctly
head(LondonBoroughs)
here::here()
library(sf)
library(here)

# Relative path using here::here
shapefile_path <- here::here("Statistical GIS Boundary Files for London",
                             "statistical-gis-boundaries-london",
                             "ESRI",
                             "London_Borough_Excluding_MHW.shp")

# Load the shapefile
LondonBoroughs <- st_read(shapefile_path)

# Confirm it loaded correctly
head(LondonBoroughs)

BoroughMap <- LondonBoroughs %>%
  dplyr::filter(stringr::str_detect(GSS_CODE, "E09")) %>%
  sf::st_transform(crs = 27700)

# Quick thematic map
tmap::qtm(BoroughMap)

writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
Sys.setenv(PATH = paste(Sys.getenv("RTOOLS40_HOME"), "usr/bin", Sys.getenv("PATH"), sep = ";"))

system("gcc --version")
install.packages("remotes")
remotes::install_github("r-tmap/tmap")
library(tmap)

install.packages(c("dplyr", "stringr", "sf", "tmap"))

library(dplyr)
library(stringr)
library(sf)
library(tmap)
# Filter, transform, and visualize
BoroughMap <- LondonBoroughs %>%
  dplyr::filter(stringr::str_detect(GSS_CODE, "E09")) %>%
  sf::st_transform(crs = 27700)

# Quick thematic map
tmap::qtm(BoroughMap)
summary(BoroughMap)
BluePlaques <- st_read("https://s3.eu-west-2.amazonaws.com/openplaques/open-plaques-london-2018-04-08.geojson")
summary(BluePlaques)
