#Earthquakes in 2014 in New Zealand
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
eqURL <- "http://quakesearch.geonet.org.nz/services/1.0.0/csv?minmag=3&startdate=2014-01-01T0:00:00&enddate=2015-01-01T0:00:00"

if(!(file.exists("localCache.csv"))){
  dataFromGeoNet <- read.csv(eqURL)
  write.csv(dataFromGeoNet, file="localCache.csv", row.names=FALSE)
}

#save par settings
oldpar <- par()

earthq <- read.csv("localCache.csv")

#match coordinate system to map
earthq$longitude[earthq$longitude < 0] <- earthq$longitude[earthq$longitude < 0] * -1
earthq <- earthq[earthq$longitude >166.15 & earthq$longitude < 179.25 & earthq$latitude > -47.45 & earthq$latitude < -34.35,]

themecol <- "#e9eab0"
png(filename = "earthquakes2014.png",width = 366, height = 480, units = "px", bg=themecol) #screen
par(oma= c(0,0,0,0))
par(mar= c(0,0,0,0))
map("nzHires", xlim = c(166, 179.4), ylim = c(-47.6, -34.2), fill=FALSE, col="#222222", mar = c(0,0,0,0), boundary= TRUE, lwd=0.4)
points(earthq$longitude,earthq$latitude, pch=3, col="#55000066", cex=0.5)
polygon(x= c(166, 166, 179.4, 179.4), y= c(-47.6, -34.2, -34.2, -47.6), lwd=3, border="black")
polygon(x= c(166, 166, 179.4, 179.4), y= c(-47.6, -34.2, -34.2, -47.6), lwd=1, border=themecol)
polygon(x= c(166.5, 166.5, 173.5, 173.5), y= c(-40, -36.5, -36.5, -40), border=NA, col=themecol)
par(font=2)
text(x= 170, y = -37, labels = "LOCATIONS OF")
text(x= 170, y = -37.5, labels = "NEW ZEALAND")
text(x= 170, y = -38, labels = "EARTHQUAKES", cex=1.8)
par(font=1)
text(x= 170, y = -38.5, labels = "Magnitude 3 and Greater")
text(x= 170, y = -39, labels = "in the year 2014")
par(font=3)
text(x= 174, y = -46.5, labels = "Source: geonet.org.nz", pos=4, cex=0.8)
text(x= 174, y = -47, labels = "Author: David Hood", pos=4, cex=0.8)
dev.off()
par(font=oldpar$font)
par(mar=oldpar$mar)
par(oma=oldpar$oma)