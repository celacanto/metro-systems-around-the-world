library(RColorBrewer)

source("functionMetroPlot.R")

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

metroPlot(x = logX, y = logY, xRange, yRange, xlabels, ylabels, xTicksPos, yTicksPos,  
          xTitle = "Population\n(millions)*", 
          yTitle = "Annual passenger rides\n          (millions)*", 
          obs = "* The scales of the axis, but not the labels, are in logarithmic scale.",
          sources= "Sources:\nhttp://en.wikipedia.org/wiki/Metro_systems_by_annual_passenger_rides\nhttp://www.maxmind.com/en/worldcities",
          filename = "metro_RideXPop_")
