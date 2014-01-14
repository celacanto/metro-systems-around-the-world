library(RColorBrewer)

source("functionMetroPlot.R")

x <- dfSubwaySummary$Year.opened
y <- dfSubwaySummary$System.length

xRange <- c(1860, 2013)
xlabels <- seq(1860, 2010, 10) 
xTicksPos <- xlabels

logY <- log(y)
yRange <- c(1.252763, 6.291569)
ylabels <- c(3.5, 6, 10, 20, 35, 60, 100, 175, 300, 540)
yTicksPos <- log(ylabels)

metroPlot(x = x, y = logY, xRange, yRange, xlabels, ylabels, xTicksPos, yTicksPos,  
          xTitle = "Year opened", 
          yTitle = "System length\n     (km)*", 
          obs = "* The scales of the axis, but not the labels, is in logarithmic scale.",
          sources= "Sources:\nhttp://en.wikipedia.org/wiki/List_of_metro_systems",
          filename = "metro_OpenXYear_")
