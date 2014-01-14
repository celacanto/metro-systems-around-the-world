library(RColorBrewer)

dfSubwaySummary <- read.csv(file = "../table/subway.csv", stringsAsFactors = FALSE)

continents <- unique(dfSubwaySummary$continent)
highilightPattern <- c(".", continents)


metroPlot <- function(x, y, xRange, yRange, xlabels, ylabels, xTicksPos, yTicksPos,  xTitle, yTitle, obs, sources, filename){
  
  nCities <- nrow(dfSubwaySummary)
  
  for(h in highilightPattern){
    

    fileName <- paste(filename, h, ".png", sep = "")
    
    png(filename = fileName, width = 1820, height = 900, bg = "white", res = 100, )
    parMar <- par("mar")
    parOma <- par("oma")  
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
    mtext(text = xTitle, side = 1, line = 3.5, col = axis.Col)
    
    axis(side = 2, at = yRange, labels =  c("", ""), lwd.ticks = 0,  col = axis.Col)
    axis(side = 2, at = yTicksPos, labels =  ylabels, lwd = 0, lwd.ticks = 1, col.axis =  axis.Col, col.ticks =  axis.Col, las = 1)
    mtext(text = yTitle, side = 2,  line = 4, col = axis.Col, las = 1, adj = 0.1, padj = -8.8)
    
    text(x = x, y = y, labels = dfSubwaySummary$X, col = colsCities, cex = 1, font = 1)
    
    lines(lowess(y~x, f=1), col = adjustcolor(axis.Col, 0.4), lwd = 6)
    
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
    mtext(obs, 
          side = SOUTH<-1, 
          line = 1, adj = 0.01, cex = 0.9,
          col = axis.Col, outer=TRUE)
    mtext(sources, 
          side = SOUTH<-1, 
          line = 3, adj = 0.99, cex = 0.8,
          col = axis.Col, outer=TRUE)
    
    dev.off()
  }
}