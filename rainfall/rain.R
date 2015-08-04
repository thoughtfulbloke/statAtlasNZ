#Average rainfall in New Zealand, selected locations
#Part of https://github.com/thoughtfulbloke/statAtlasNZ
#MIT Licenced
#Author: David Hood

#packages:
if(!(require("maps"))){
  install.packages("maps")
  require(maps)
}
if(!(require("mapdata"))){
  install.packages("mapdata")
  require(mapdata)
}

#data
rnURL <- "http://www.niwa.co.nz/sites/www.dev2.niwa.co.nz/files/sites/default/files/mean_monthly_rainfall_mm.csv"
#for other options see http://www.niwa.co.nz/education-and-training/schools/resources/climate
# the cliflo database will give weather station latitude, longitude, and data but needs registration so can't be used as easily in an example script
#read data
if(!(file.exists("rainfall.csv"))) {
  download.file(rnURL, destfile="rainfall.csv")
}

#because it is not an "easily" set out csv file I am rading the data then the headings
rainfall <-  read.csv("rainfall.csv", stringsAsFactors=FALSE, skip=5)
names(rainfall) <- names(read.csv("rainfall.csv", skip=4, nrow=1))

#get placenames. 13.8 MB download so making local cache for repeat running
placeURL <- "http://www.linz.govt.nz/system/files_force/media/file-attachments/gaz_names.csv"
if(!(file.exists("gaz_names.csv"))) {
  download.file(placeURL, destfile="gaz_names.csv")
}
places <- read.csv("gaz_names.csv", stringsAsFactors = FALSE)

#merge the raninfall with the lat and long
combined <- merge(rainfall, places[,c("name", "crd_latitude", "crd_longitude")], by.x="LOCATION", by.y="name")
#check my results here (as you do after a merge) and discover that because Kaikoura and Lake Tekapo and Tauranga have multiple entries with that name, they have resulted in duplicate merges
#so I exlude the ones I don't want and try again
places <- places[-(which(places$name=="Kaikoura" & places$land_district=="Gisborne")),]
places <- places[-(which(places$name=="Lake Tekapo" & places$feat_type=="Locality")),]
places <- places[-(which(places$name=="Tauranga" & places$land_district=="Wellington")),]
places <- places[-(which(places$name=="Tauranga" & places$land_district=="Gisborne")),]
combined <- merge(rainfall, places[,c("name", "crd_latitude", "crd_longitude")], by.x="LOCATION", by.y="name")
#another set of checks
print(paste("entries in combined", length(combined$LOCATION)))
print(paste("unique entries in combined", length(unique(combined$LOCATION))))
print(paste("entries in rainfall sheet", length(rainfall$LOCATION)))
print(paste("unique entries in rainfall sheet", length(unique(rainfall$LOCATION))))
#clearly I lost a couple of entries
rainfall$LOCATION[!(rainfall$LOCATION %in% combined$LOCATION)]
#Investigating the data, to get matches I need Mount Cook and Chatham Islands.
#I check for "Cook"
#View(places[grep("Cook", places$name),])
#I can use Aoraki/Mount Cook if I get rid of the hill and use the town
places <- places[-(which(places$name=="Aoraki/Mount Cook" & places$feat_type=="Hill")),]
rainfall$LOCATION[rainfall$LOCATION == "Mt Cook"] <- "Aoraki/Mount Cook"
#I check "Chatham Is"
#View(places[grep("Chatham Is", places$name),])
# an easy fix to make it Chatham Island
rainfall$LOCATION[rainfall$LOCATION == "Chatham Islands"] <- "Chatham Island"
combined <- merge(rainfall, places[,c("name", "crd_latitude", "crd_longitude")], by.x="LOCATION", by.y="name")
combined$wetness <- combined$YEAR / max(combined$YEAR)

plotrain <- function(x){
  baseheight <- .4
  vert <- as.numeric(x[15])
  horz <- as.numeric(x[16])
  scaler <- as.numeric(x[17]) * baseheight
  polygon(x=c(horz,horz, horz+.03,horz+.03), y=c(vert, vert + baseheight, vert+ baseheight, vert), col="black")
  horz <- horz+.02
  polygon(x=c(horz,horz, horz + .3, horz + .3), y=c(vert, vert + scaler, vert+ scaler, vert), col="blue")
}

#save par settings
oldpar <- par()


#configure other stuff
mapN <- -30.2
mapS <- -51.9
mapW <- 162.0
mapE <- 183.7


#prep map canvas
themecol <- "#e9eab0"
png(filename = "meanRain.png",width = 366, height = 480, units = "px", bg=themecol) #screen
par(oma= c(0,0,0,0))
par(mar= c(0,0,0,0))
map("nzHires", xlim = c(mapW, mapE), ylim = c(mapS, mapN), fill=FALSE, col="#222222", mar = c(0,0,0,0), boundary= TRUE, lwd=0.4)


#add decorative text
par(font=2)
text(x= 166, y = -34.5, labels = "Rainfall in ", cex=0.9)
text(x= 166, y = -35, labels = "NEW ZEALAND", cex=0.9)
text(x= 166, y = -35.6, labels = "SELECTED AREAS", cex=1.2)
par(font=1)
text(x= 166, y = -36.2, labels = "Average Annual rain", cex=0.8)
text(x= 166, y = -36.7, labels = "1981-2010", cex=0.8)
par(font=3)
text(x= 175.05, y = -47.1, labels = "Sources: www.niwa.co.nz", pos=4, cex=0.8)
text(x= 175.05, y = -47.6, labels = "               www.linz.govt.nz", pos=4, cex=0.8)
text(x= 175.05, y = -48.1, labels = "Author: David Hood", pos=4, cex=0.8)

lines(x=c(177,177), y=c(-34,-34.4))
par(font=2)
text(177, y= -32.9, pos=4, labels="Scale (mm)")
text(177, y= -33.4, pos=4, labels="of rainfall")

par(font=1)
text(177, y= -34.5, pos=4, labels="0", cex=0.7)
text(177, y= -34, pos=4, labels=max(aggrecom$YEAR), cex=0.7)

######## Map annotations
apply(combined, 1, plotrain)

#finish and cleanup
dev.off()
par(font=oldpar$font)
par(mar=oldpar$mar)
par(oma=oldpar$oma)

