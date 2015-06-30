#Age Distributions of select electorates in  2013 in New Zealand
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
elURL <- "http://www3.stats.govt.nz/meshblock/2013/csv/2013_mb_dataset_Total_New_Zealand_CSV.zip"

if(!(file.exists("localCache.zip"))){
download.file(elURL, destfile="localCache.zip", mode="wb")
  unzip("localCache.zip")
}

#save par settings
oldpar <- par()

#read census
fullcensus <-  read.csv("2013-mb-dataset-Total-New-Zealand-Individual-Part-1.csv", stringsAsFactors=FALSE)

#configure other stuff
cenAgeCols <- 51:63
regions <- read.csv("whatGoesWhere.csv")
regions$ylat <- regions$ylat * -1 #to match map corordinate system of south = negative
mapN <- -30.2
mapS <- -51.6
mapW <- 162
mapE <- 183.4
regions$lx <- (mapE - mapW)*regions$lx + mapW
regions$ly <- (mapN - mapS)*regions$ly + mapS

#prep map canvas
themecol <- "#e9eab0"
png(filename = "ageRegions2013.png",width = 366, height = 480, units = "px", bg=themecol) #screen
par(oma= c(0,0,0,0))
par(mar= c(0,0,0,0))
map("nzHires", xlim = c(mapW, mapE), ylim = c(mapS, mapN), fill=FALSE, col="#222222", mar = c(0,0,0,0), boundary= TRUE, lwd=0.4)

#add decorative text
par(font=2)
text(x= 166, y = -39.5, labels = "AGE DISTRIBUTION OF", cex=0.9)
text(x= 166, y = -40, labels = "NEW ZEALAND", cex=0.9)
text(x= 166, y = -40.6, labels = "SELECTED AREAS", cex=1.2)
par(font=1)
text(x= 166, y = -41.2, labels = "Highlighting 10-14 year olds", cex=0.8)
text(x= 166, y = -41.7, labels = "in the year 2013", cex=0.8)
par(font=3)
text(x= 162.05, y = -43.1, labels = "Source: stats.govt.nz", pos=4, cex=0.8)
text(x= 162.05, y = -43.6, labels = "Author: David Hood", pos=4, cex=0.8)
text(x= 180.05, y = -50.9, labels = "From age\n0 (upper) to\n65 (lower) in\n5 year steps", pos=4, cex=0.6)

######## Map annotations
addGuides <- function(x){
  points(x[4],x[3], pch=19)
  lines(c(x[4],x[9]),c(x[3],x[10]))
}
apply(regions, 1, addGuides)


############### Now come the subfigures after the other main map and annotations

barPlotSubregion <- function(x){
  plotdata <- rev(100 * as.numeric(fullcensus[x[2],cenAgeCols])/sum(as.numeric(fullcensus[x[2],cenAgeCols])))
  par(fig= x[5:8], new=TRUE)
  par(oma= c(0,0,0,0))
  par(mar= c(0,0,1,0))
  barplot(plotdata, horiz=TRUE, axes=FALSE, axisnames=FALSE, col=themecol, main=x[1], cex.main=0.8, border="#888888", xlim=c(0,14))
  important <- numeric(length=13)
  important[11] <- plotdata[11]
  barplot(important, horiz=TRUE, add=TRUE, col="#550000",  border=themecol, axes=FALSE, axisnames=FALSE)
  box(which="figure", col="#222222")
}

apply(regions, 1, barPlotSubregion)

##close and cleanup
dev.off()
par(font=oldpar$font)
par(mar=oldpar$mar)
par(oma=oldpar$oma)
par(fig=oldpar$fig)