install.packages("here")
library(here)
LondonDataOSK <- read.csv("C:/Users/yourusername/Documents/.../05 practical/ward-profiles-excel-version.csv", header = TRUE, sep = ",", encoding = "latin1")

LondonData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv",
                       locale = locale(encoding = "latin1"),
                       na = "n/a")
class(LondonData)
Datatypelist <- LondonData %>% 
  summarise_all(class) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")

Datatypelist
LondonData <- read_csv("https://data.london.gov.uk/download/ward-profiles-and-atlas/772d2d64-e8c6-46cb-86f9-e52b4c7851bc/ward-profiles-excel-version.csv", 
                      locale = locale(encoding = "latin1"))
LondonData <- edit(LondonData)
summary(df)
LondonData%>%
  colnames()%>%
  # just look at the head, top5
  head()
LondonBoroughs<-LondonData[626:658,]
LondonBoroughs<-LondonData%>%
  dplyr::slice(626:658)
Femalelifeexp<- LondonData %>% 
  filter(`Female life expectancy -2009-13`>90)
install.packages("stringr")
library(stringr)

LondonBoroughs<- LondonData %>% 
  filter(str_detect(`New code`, "^E09"))
LondonBoroughs$`Ward name`
