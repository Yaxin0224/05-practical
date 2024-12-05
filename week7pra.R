library(here)
library(sf)
library(tidyverse)

# 使用实际存在的文件名替换路径
LondonWards <- st_read(here("London-wards-2018_ESRI", "London_Ward.shp"))

# 打印结果
print(LondonWards)
LondonWards <- st_read(here("London-wards-2018_ESRI", "London_Ward_CityMerged.shp"))

# 打印结果
print(LondonWards)
LondonWardsMerged <- st_read("C:/Users/z1782/OneDrive - University College London/Attachments/005/practical/05 practical/Statistical GIS Boundary Files for London/statistical-gis-boundaries-london/ESRI/London_Ward_CityMerged.shp")%>%
  st_transform(.,27700)
WardData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv",
                     locale = locale(encoding = "latin1"),
                     na = c("NA", "n/a")) %>% 
  clean_names()

LondonWardsMerged <- LondonWardsMerged %>% 
  left_join(WardData, 
            by = c("GSS_CODE" = "new_code"))%>%
  dplyr::distinct(GSS_CODE, .keep_all = T)%>%
  dplyr::select(GSS_CODE, ward_name, average_gcse_capped_point_scores_2014)
st_crs(LondonWardsMerged)
##Now get the location of all Blue Plaques in the City
#BluePlaques <- st_read("https://s3.eu-west-2.amazonaws.com/openplaques/open-plaques-london-2018-04-08.geojson")
# 打印数据结构
str(BluePlaques)

# 查看前几行数据
head(BluePlaques)

# 显示摘要信息
summary(BluePlaques)
# 下载文件到本地
download.file("https://s3.eu-west-2.amazonaws.com/openplaques/open-plaques-london-2018-04-08.geojson", 
              destfile = "open-plaques-london-2018-04-08.geojson")
BluePlaques <- st_read("open-plaques-london-2018-04-08.geojson")
colnames(BluePlaques)
head(BluePlaques)
summary(BluePlaques)
st_bbox(BluePlaques)
library(sf)

# 转换为 EPSG:27700
BluePlaques <- st_transform(BluePlaques, crs = 27700)

# 检查转换后的坐标系
st_crs(BluePlaques)
install.packages("tmap", dependencies = TRUE)

library(tmap)

?tmap_mode
?tm_shape

tmap_mode("plot")

tm_shape(LondonWardsMerged) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaques) +
  tm_dots(col = "blue")
summary(BluePlaques)
