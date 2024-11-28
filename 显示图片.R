library(sf)
library(dplyr)
library(stringr)
file_path <- "C:/Users/z1782/OneDrive - University College London/Attachments/005/practical/05 practical/LAD_Dec_2015_FCB_GB.shp"
shapefile <- st_read(file_path)
names(shapefile)
LondonMap <- shapefile %>%
  filter(str_detect(lad15cd, "^E09"))
print(LondonMap)
library(tmap)
qtm(LondonMap)
install.packages("janitor")
library(janitor)
LondonData <- clean_names(LondonData)

#EW is the data we read in straight from the web
BoroughDataMap <- shapefile %>%
  clean_names()%>%
  # the . here just means use the data already loaded
  filter(str_detect(lad15cd, "^E09"))%>%
  merge(.,
        LondonData, 
        by.x="lad15cd", 
        by.y="new_code",
        no.dups = TRUE)%>%
  distinct(.,lad15cd,
           .keep_all = TRUE)
BoroughDataMap2 <- shapefile %>% 
  clean_names() %>%
  filter(str_detect(lad15cd, "^E09"))%>%
  left_join(., 
            LondonData,
            by = c("lad15cd" = "new_code"))
library(tmap)
library(tmaptools)
tmap_mode("plot")
qtm(BoroughDataMap, 
    fill = "rate_of_job_seekers_allowance_jsa_claimants_2015")


tmap_mode("plot")

# 使用 tmap 绘制地图，并叠加 OpenStreetMap 底图
tm_shape(boroughDataMap) +
  tm_polygons("rate_of_job_seekers_allowance_jsa_claimants_2015",
              palette = "YlOrRd", style = "pretty", title = "Job Seeker Allowance Rate") +
  tm_basemap(server = "OpenStreetMap") +
  tm_layout(title = "London Job Seeker Allowance Claimants (2015)",
            legend.outside = TRUE)