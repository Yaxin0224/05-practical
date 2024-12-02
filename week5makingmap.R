library(sf)
library(here)

setwd("C:/GISFiles/ESRI/")
library(sf)
Londonborough <- st_read("C:/GISFiles/ESRI/London_Borough_Excluding_MHW.shp") %>% 
  st_transform(27700)
library(sf)

# 使用完整路径读取文件
OSM <- st_read("C:/GISFiles/greater_London_lastest_free.shp") %>%
  st_transform(27700)
st_layers("C:/GISFiles/greater_London_lastest_free.shp")
OSM <- st_read("C:/GISFiles/greater_London_lastest_free.shp", layer = "gis_osm_pois_a_free_1 ") %>%
  st_transform(27700)
library(sf)

# 尝试读取 gis_osm_places_a_free_1 图层
OSM <- st_read("C:/GISFiles/greater_London_lastest_free.shp", layer = "gis_osm_places_a_free_1") %>%
  st_transform(27700)
join_example <-  st_join(Londonborough, OSM)

head(join_example)
library(sf)
library(tmap)
library(tmaptools)
library(tidyverse)
library(here)

# read in all the spatial data and 
# reproject it 

OSM <- st_read("C:/GISFiles/greater_London_lastest_free.shp", layer = "gis_osm_places_a_free_1") %>%
  st_transform(27700) %>%
  #select hotels only
  filter(fclass == 'hotel')
Worldcities <- st_read("C:/GISFiles/World_Cites/World_Cities.shp") %>%
  st_transform(27700)
Worldcities <- st_read("C:/GISFiles/World_Cites/World_Cities.shp") %>%
  st_transform(27700)
library(sf)

# 使用完整路径读取 UK_outline 数据
UK_outline <- st_read("C:/GISFiles/gadm41/gadm41_GBR_0.shp") %>%
  st_transform(27700)
# 使用完整路径读取 Londonborough 数据
Londonborough <- st_read("C:/GISFiles/Statistical GIS Boundary Files for London/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp") %>%
  st_transform(27700)


