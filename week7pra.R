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

BluePlaquesSub <- BluePlaques[LondonWardsMerged,]

tm_shape(LondonWardsMerged) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaquesSub) +
  tm_dots(col = "blue")
library(sf)

example<-st_intersects(LondonWardsMerged, BluePlaquesSub)

example

joined_data <- LondonWardsMerged %>% st_join(BluePlaquesSub)
colnames(joined_data)
class(LondonWardsMerged$ward_name)
# 分步检查 join 后数据
joined_data <- LondonWardsMerged %>% st_join(BluePlaquesSub)

# 检查字段
colnames(joined_data)

# 过滤数据
library(dplyr)
filtered_data <- joined_data %>%
  filter(ward_name == "Kingston upon Thames - Coombe Hill")

library(sf)
points_sf_joined <- LondonWardsMerged%>%
  mutate(n = lengths(st_intersects(., BluePlaquesSub)))%>%
  janitor::clean_names()%>%
  #calculate area
  mutate(area=st_area(.))%>%
  #then density of the points per ward
  mutate(density=n/area)%>%
  #select density and some other variables 
  dplyr::select(density, ward_name, gss_code, n, average_gcse_capped_point_scores_2014)
points_sf_joined<- points_sf_joined %>%                    
  group_by(gss_code) %>%         
  summarise(density = first(density),
            wardname= first(ward_name),
            plaquecount= first(n))

tm_shape(points_sf_joined) +
  tm_polygons("density",
              style="jenks",
              palette="PuOr",
              midpoint=NA,
              popup.vars=c("wardname", "density"),
              title="Blue Plaque Density")
install.packages("spdep", dependencies = TRUE)
library(spdep)
coordsW <- points_sf_joined%>%
  st_centroid()%>%
  st_geometry()

plot(coordsW,axes=TRUE)

#create a neighbours list
LWard_nb <- points_sf_joined %>%
  poly2nb(., queen=T)
summary(LWard_nb)
#plot them
plot(LWard_nb, st_geometry(coordsW), col="red")
#add a map underneath
plot(points_sf_joined$geometry, add=T)
Lward.lw <- LWard_nb %>%
  nb2mat(., style="B")

sum(Lward.lw)
sum(Lward.lw[1,])
Lward.lw <- LWard_nb %>%
  nb2listw(., style="C")
I_LWard_Global_Density <- points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  moran.test(., Lward.lw)

I_LWard_Global_Density

C_LWard_Global_Density <- 
  points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  geary.test(., Lward.lw)

C_LWard_Global_Density

G_LWard_Global_Density <- 
  points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  globalG.test(., Lward.lw)

G_LWard_Global_Density
I_LWard_Local_count <- points_sf_joined %>%
  pull(plaquecount) %>%
  as.vector()%>%
  localmoran(., Lward.lw)%>%
  as_tibble()

I_LWard_Local_Density <- points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  localmoran(., Lward.lw)%>%
  as_tibble()

#what does the output (the localMoran object) look like?
slice_head(I_LWard_Local_Density, n=5)
points_sf_joined <- points_sf_joined %>%
  mutate(plaque_count_I = as.numeric(I_LWard_Local_count$Ii))%>%
  mutate(plaque_count_Iz =as.numeric(I_LWard_Local_count$Z.Ii))%>%
  mutate(density_I =as.numeric(I_LWard_Local_Density$Ii))%>%
  mutate(density_Iz =as.numeric(I_LWard_Local_Density$Z.Ii))
breaks1<-c(-1000,-2.58,-1.96,-1.65,1.65,1.96,2.58,1000)
install.packages("RColorBrewer")
library(RColorBrewer)
MoranColours<- rev(brewer.pal(8, "RdGy"))
library(tmap)

tm_shape(points_sf_joined) +
  tm_polygons("plaque_count_Iz",
              style="fixed",
              breaks=breaks1,
              palette=MoranColours,
              midpoint=NA,
              title="Local Moran's I, Blue Plaques in London")
library(dplyr)
library(magrittr)
library(spdep)

Gi_LWard_Local_Density <- points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  localG(., Lward.lw)

head(Gi_LWard_Local_Density)
points_sf_joined <- points_sf_joined %>%
  mutate(density_G = as.numeric(Gi_LWard_Local_Density))
library(RColorBrewer)

GIColours<- rev(brewer.pal(8, "RdBu"))

#now plot on an interactive map
tm_shape(points_sf_joined) +
  tm_polygons("density_G",
              style="fixed",
              breaks=breaks1,
              palette=GIColours,
              midpoint=NA,
              title="Gi*, Blue Plaques in London")
slice_head(points_sf_joined, n=2)
# 安装 tidyr 包
install.packages("tidyr")

# 加载 tidyr 包
library(tidyr)

Datatypelist <- LondonWardsMerged %>% 
  st_drop_geometry()%>%
  summarise_all(class) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")

Datatypelist

I_LWard_Local_GCSE <- LondonWardsMerged %>%
  arrange(GSS_CODE)%>%
  pull(average_gcse_capped_point_scores_2014) %>%
  as.vector()%>%
  localmoran(., Lward.lw)%>%
  as_tibble()

points_sf_joined <- points_sf_joined %>%
  arrange(gss_code)%>%
  mutate(GCSE_LocIz = as.numeric(I_LWard_Local_GCSE$Z.Ii))


tm_shape(points_sf_joined) +
  tm_polygons("GCSE_LocIz",
              style="fixed",
              breaks=breaks1,
              palette=MoranColours,
              midpoint=NA,
              title="Local Moran's I, GCSE Scores")

G_LWard_Local_GCSE <- LondonWardsMerged %>%
  dplyr::arrange(GSS_CODE)%>%
  dplyr::pull(average_gcse_capped_point_scores_2014) %>%
  as.vector()%>%
  localG(., Lward.lw)

points_sf_joined <- points_sf_joined %>%
  dplyr::arrange(gss_code)%>%
  dplyr::mutate(GCSE_LocGiz = as.numeric(G_LWard_Local_GCSE))

tm_shape(points_sf_joined) +
  tm_polygons("GCSE_LocGiz",
              style="fixed",
              breaks=breaks1,
              palette=GIColours,
              midpoint=NA,
              title="Gi*, GCSE Scores")