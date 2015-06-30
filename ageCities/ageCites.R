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

fullcensus <-  read.csv("2013-mb-dataset-Total-New-Zealand-Individual-Part-1.csv", stringsAsFactors=FALSE)
christchurch <- 100 * as.numeric(fullcensus[48955,c(51:64)])/sum(as.numeric(fullcensus[48955,c(51:64)]))
important <- numeric(length = length(christchurch))
important[3] <- christchurch[3]


themecol <- "#e9eab0"
png(filename = "ageCities2013.png",width = 366, height = 480, units = "px", bg=themecol) #screen
par(oma= c(0,0,0,0))
par(mar= c(0,0,0,0))
map("nzHires", xlim = c(162, 183.4), ylim = c(-51.6, -30.2), fill=FALSE, col="#222222", mar = c(0,0,0,0), boundary= TRUE, lwd=0.4)
par(font=2)
text(x= 167, y = -40, labels = "AGE DISTRIBUTION OF")
text(x= 167, y = -40.5, labels = "NEW ZEALAND")
text(x= 167, y = -41, labels = "SELECTED AREAS", cex=1.3)
par(font=1)
text(x= 167, y = -41.5, labels = "Highlighting 10-14 year olds", cex=0.8)
text(x= 167, y = -42, labels = "in the year 2013", cex=0.8)
par(font=3)
text(x= 174, y = -46.5, labels = "Source: stats.govt.nz", pos=4, cex=0.8)
text(x= 174, y = -47, labels = "Author: David Hood", pos=4, cex=0.8)

#christchurch
par(fig= c(.75,.95,.23,.43), new=TRUE)
par(oma= c(0,0,0,0))
par(mar= c(0,0,0,0))

barplot(christchurch, horiz=TRUE)
barplot(important, horiz=TRUE, add=TRUE, col="#550000")


dev.off()
par(font=oldpar$font)
par(mar=oldpar$mar)
par(oma=oldpar$oma)
par(fig=oldpar$fig)