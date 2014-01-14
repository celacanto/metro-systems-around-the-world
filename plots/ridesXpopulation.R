library(RColorBrewer)

dfSubwaySummary <- read.csv(file = "../table/subway.csv", stringsAsFactors = FALSE)


continents <- unique(dfSubwaySummary$continent)
highilightPattern <- c(".", continents)


x <- dfSubwaySummary$Population
y <- dfSubwaySummary$Rides


logX <- log(x)
xRange <- range(logX)
xlabels <- c(0.1, 0.2, 0.5, 1.5, 4, 11, 30) 
xTicksPos <- log(xlabels * 1000000)
xTicksPos[1] <- xRange[1]

logY <- log(y)
yRange <- c(13.12236, 22.23481)
ylabels <- c(0.5, 1.5, 4.5, 12, 35, 90, 245, 660, 1800, 4500)
yTicksPos <- log(ylabels * 1000000)
yTicksPos[1] <- yRange[1]

nCities <- nrow(dfSubwaySummary)



for(h in highilightPattern){
  
  fileName <- paste("Subway_RideXPop_", h, ".png", sep = "")
  png(filename = fileName, width = 1820, height = 900, bg = "white", res = 100, )
  
  par("mar" = c(5.1, 5.1, 8, 2.1))
  par("oma" = c(5, 0, 0, 0))
  axis.Col <- "#2F3440"
  par(family = "Palatino")
  cexCities <- rep(1, nCities)
  colsCities <- rep(NA, nCities)
  colsContinent <- brewer.pal(8, "Set1")[-c(5,6)]
  for(i in seq_along(continents)){
    colsCities[dfSubwaySummary$continent == continents[i]] <- colsContinent[i]
  }
  
  selectNoHig <- !grepl(pattern = h, x = dfSubwaySummary$continent)
  colsCities[selectNoHig] <- adjustcolor(colsCities[selectNoHig], 0.2)
  cexCities[selectNoHig] <- 0.8
      
  plot(xRange, yRange, type="n", axes=F, xlab="", ylab="")
  
  axis(side = 1, at = xRange, labels =  c("", ""), lwd.ticks = 0,  col = axis.Col)
  axis(side = 1, at = xTicksPos, labels =  xlabels, lwd = 0, lwd.ticks = 1, col.axis =  axis.Col, col.ticks =  axis.Col)
  mtext(text = "Population\n(millions)*", side = 1, line = 3.5, col = axis.Col)
  
  axis(side = 2, at = yRange, labels =  c("", ""), lwd.ticks = 0,  col = axis.Col)
  axis(side = 2, at = yTicksPos, labels =  ylabels, lwd = 0, lwd.ticks = 1, col.axis =  axis.Col, col.ticks =  axis.Col, las = 1)
  mtext(text = "Annual passenger rides\n          (millions)*", side = 2,  line = 4, col = axis.Col, las = 1, adj = 0.1, padj = -8.8)
  
  text(x = logX, y = logY, labels = dfSubwaySummary$X, col = colsCities, cex = 1, font = 1)
  
  lines(lowess(logY~logX, f=1), col = adjustcolor(axis.Col, 0.4), lwd = 6)
  
  par("xpd" = TRUE)
  names(colsContinent) <- unique(dfSubwaySummary$continent)
  namesContOrder <- names(sort(table(dfSubwaySummary$continent), decreasing = TRUE))
  legend(x = par("usr")[2], y = par("usr")[4], text.font= 4,  
         bg = "#FCFCF7",
         xjust = 1, yjust = 0, ncol=1, 
         legend = namesContOrder,
         text.col = colsContinent[namesContOrder], 
         box.lwd = 0.1)
  par("xpd" = FALSE)
  
  
  box("inner", lty = "solid", col = axis.Col, lwd = 0.5)
  mtext("* The scales of the axis, but not the labels, are in logarithmic scale.", 
        side = SOUTH<-1, 
        line = 1, adj = 0.01, cex = 0.9,
        col = axis.Col, outer=TRUE)
  mtext("Sources:\nhttp://en.wikipedia.org/wiki/Metro_systems_by_annual_passenger_rides\nhttp://www.maxmind.com/en/worldcities", 
        side = SOUTH<-1, 
        line = 3, adj = 0.99, cex = 0.8,
        col = axis.Col, outer=TRUE)
  
  dev.off()
}
