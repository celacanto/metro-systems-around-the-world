library(XML)
library(stringr)

wikiTableFormat <- function(table){
  # Clean a wikipedia table returned by readHTMLTable function from XML package
  #
  # Args:
  #   table: table returned from readHTMLTable function
  #
  # Returns:
  #   The table inputed as a data frame
  tableMtx <- as.matrix(table)
  tableMtx[] <- str_trim(gsub("\\[.*\\]|\\(.*\\)|\\,|[[:punct:]]km|.*\\!.[[:punct:]]?|^[[:punct:]]+", "", tableMtx))
  tableDF <- as.data.frame(tableMtx, stringsAsFactors = FALSE)
}

noAccentLowerCase <- function(string){
  # Remove accent and put the string in lower case -- for compare strings
  #
  # Args:
  #   string: the string to convert
  #
  # Returns:
  #   the string converted
  tolower(iconv(string, to="ASCII//TRANSLIT"))
}


# List of metro systems table
# =====================================================================================================================

urlSubwayWikiLink <- "http://en.wikipedia.org/wiki/List_of_metro_systems"
subwayRaw <- readHTMLTable(urlSubwayWikiLink, trim = TRUE)[[2]]
subway <- wikiTableFormat(subwayRaw)
subway[, 4:7] <- sapply(subway[, 4:7], as.numeric)


#### To be abble to revert the remove of accent
locationWithAccent <- subway$Location
locationNoAccent <- noAccentLowerCase(subway$Location)
names(locationWithAccent) <- locationNoAccent

countryWithAccent <- subway$Country
countryNoAccent <- noAccentLowerCase(subway$Country)
names(countryWithAccent) <- countryNoAccent


subway$Location <- locationNoAccent
subway$Country <- countryNoAccent
colnames(subway)[c(1,3)] <- c("City", "System")

metroHtml <- readLines(urlSubwayWikiLink)
afterTrLines <- metroHtml[grep("^<tr>$|^<tr class=\"sort\">$", metroHtml) + 3]
afterTrLinesurls <- afterTrLines[grep("^<td><a href=", afterTrLines)][1:165]
citiesUrlRelative <- gsub("^<td><a href=\"/|\".*?$",  "", afterTrLinesurls)
subway$WikiMetroURl <- citiesUrlRelative

# Metro systems by annual passenger rides
# ======================================================================================================================

urlAnnualPassengerRides <- "http://en.wikipedia.org/wiki/Metro_systems_by_annual_passenger_rides"
ridesRaw <- readHTMLTable(urlAnnualPassengerRides, trim = TRUE)[[1]]
rides <- wikiTableFormat(ridesRaw)[,-c(1,5)]
rides$Ridership <- as.numeric(gsub(" million", "", rides$Ridership)) * 1000000
rides$Year <- as.numeric(gsub("^FY|/\\d+", "", rides$Year))


ridesHtml <- readLines(urlAnnualPassengerRides)
afterTrLines <- ridesHtml[grep("^<tr>$|^<tr class=\"sort\">$", ridesHtml) + 2]
afterTrLinesurls <- afterTrLines[grep("^<td><a href=", afterTrLines)][1:150]
citiesUrlRelative <- gsub("^<td><a href=\"/|\".*?$",  "", afterTrLinesurls)
rides$WikiMetroURl <- citiesUrlRelative



# Cities Populations
# ==========================================================================================================================

download.file("http://download.maxmind.com/download/worldcities/worldcitiespop.txt.gz", destfile= "worldcitiespop.txt.gz")
popCitiesRaw <- read.csv("worldcitiespop.txt.gz")
popCities <- popCitiesRaw[!is.na(popCitiesRaw$Population),][c(1,2,5)]
colnames(popCities)[1] <-  "Country.Code" 
file.remove("worldcitiespop.txt.gz")

download.file("http://geolite.maxmind.com/download/geoip/database/GeoIPv6.csv.gz", destfile= "GeoIPv6.csv.gz")
coutrys <- unique(read.csv("GeoIPv6.csv.gz", header = FALSE)[,5:6])
coutrys <- apply(coutrys, 2, noAccentLowerCase)
colnames(coutrys) <- c("Country.Code", "Country")
file.remove("GeoIPv6.csv.gz")


popCitiesCountry <- merge(coutrys, popCities, all.x = TRUE)
popCitiesCountry <- popCitiesCountry[,-1]

# Merging tables
# =============================================================================================================================

subwayPop <- merge(x = subway, y = popCitiesCountry, all.x = TRUE)
# The ones it not found manual look in the wikipedia
subwayPop$Population[subwayPop$City == "beijing"] <- 20693000
subwayPop$Population[subwayPop$City == "buenos aires"] <- 2890151
subwayPop$Population[subwayPop$City == "busan"] <- 3590101
subwayPop$Population[subwayPop$City == "chennai"] <- 6500000
subwayPop$Population[subwayPop$City == "daegu"] <- 2527566
subwayPop$Population[subwayPop$City == "daejeon"] <- 1539154
subwayPop$Population[subwayPop$City == "dnipropetrovsk"] <- 1001612
subwayPop$Population[subwayPop$City == "donostia"] <- 186409
subwayPop$Population[subwayPop$City == "fukuoka"] <- 1483052
subwayPop$Population[subwayPop$City == "gwangju"] <- 1471324
subwayPop$Population[subwayPop$City == "hong kong"] <- 7184000
subwayPop$Population[subwayPop$City == "incheon"] <- 2900898
subwayPop$Population[subwayPop$City == "kaohsiung"] <- 2769072
subwayPop$Population[subwayPop$City == "kazan"] <- 1143535
subwayPop$Population[subwayPop$City == "kharkiv"] <- 1442910
subwayPop$Population[subwayPop$City == "kolkata"] <- 4486679
subwayPop$Population[subwayPop$City == "kyoto"] <- 1473746
subwayPop$Population[subwayPop$City == "mashhad"] <- 3069941
subwayPop$Population[subwayPop$City == "mexico city"] <- 8851080
subwayPop$Population[subwayPop$City == "moscow"] <- 11503501
subwayPop$Population[subwayPop$City == "new york city"] <- 8336697
subwayPop$Population[subwayPop$City == "nizhny novgorod"] <- 1250619
subwayPop$Population[subwayPop$City == "osaka"] <- 2666371
subwayPop$Population[subwayPop$City == "palma de mallorca"] <- 401270
subwayPop$Population[subwayPop$City == "pyongyang"] <- 2581076
subwayPop$Population[subwayPop$City == "saint petersburg"] <- 4879566
subwayPop$Population[subwayPop$City == "samara"] <- 1164685
subwayPop$Population[subwayPop$City == "san francisco bay area"] <- 7150000
subwayPop$Population[subwayPop$City == "san juan"] <- 395326
subwayPop$Population[subwayPop$City == "sapporo"] <- 1918096
subwayPop$Population[subwayPop$City == "seoul"] <- 10442426
subwayPop$Population[subwayPop$City == "seville"] <- 703021
subwayPop$Population[subwayPop$City == "taipei"] <- 2652959
subwayPop$Population[subwayPop$City == "tehran"] <- 8244535
subwayPop$Population[subwayPop$City == "washington d.c."] <- 646449
subwayPop$Population[subwayPop$City == "xi'an"] <- 8467837
subwayPop$Population[subwayPop$City == "yekaterinburg"] <- 1349772
subwayPop$Population[subwayPop$City == "yokohama"] <- 3697894
subwayPop$Population[subwayPop$City == "zhengzhou"] <- 8626505
subwayPop$Population[subwayPop$City == "novosibirsk"] <- 1473754


subwayPopRides <- merge(subwayPop, rides, by ="WikiMetroURl", all.x = TRUE)
# The ones that the url was not the same. Insert manual
subwayPopRides$Ridership[subwayPopRides$System.x == "Bursa Metro"] <- 91.25 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Chennai Mass Rapid Transit System"] <- 29.2 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Daegu Subway"] <- 126.5 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Daejeon Subway"] <- 38 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Kobe Rapid Railway"] <- 121 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Manila Metro Rail Transit System"] <- 405.3 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Metro de Madrid"] <- 601.5 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Metro Rail"] <- 48.7 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "yokohama"] <- 198 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "bangkok"] <- 194.1 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "RapidKL Rail"] <- 146.4 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Copenhagen S-train"] <- 54.3 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Suzhou Rail Transit"] <- 25.38  * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Tokyo Waterfront Area Rapid Transit"] <- 72 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Toronto Subway and RT"] <- 318.8 * 1000000
subwayPopRides$Ridership[subwayPopRides$System.x == "Yamanote Line"] <- 1359715155


# Merge same cities rows and keep just complete cases (lines without NA)
# ==============================================================================================================================================

subwayPopRides <- unique(subwayPopRides[, c("City", "System.x", "Year opened", "Stations", "System length", "Population", "Ridership","Country")])
cities <- unique(subwayPopRides$City) 
mtxSubwaySummary <- matrix(ncol = 7, nrow = length(cities), 
                           dimnames = list(cities, c("Year.opened", "Rides", "System.length", "Stations", "Population", "Systems", "Country")))
for(i in cities){
  citieTable <- subwayPopRides[subwayPopRides$City == i,]
  citieTable <- citieTable[order(citieTable$Population, decreasing = TRUE),]
  citieTable <- citieTable[!duplicated(citieTable$System.x),]
  
  year.opened <- min(citieTable[,"Year opened"])    
  riderShip <- sum(unique(citieTable$Ridership))
  system.length <- sum(unique(citieTable[, "System length"]))
  stations <- sum(citieTable[, "Stations"])
  population <- max(citieTable$Population)
  systems <- paste(citieTable$System.x, collapse = " / ")
  country <- unique(citieTable$Country)
  mtxSubwaySummary[i, ] <- c(year.opened, riderShip, system.length, stations, population, systems, country) 
}

mtxSubwaySummaryComplete <- mtxSubwaySummary[complete.cases(mtxSubwaySummary),]

dfSubwaySummary <- as.data.frame(mtxSubwaySummaryComplete, stringsAsFactors = FALSE)
dfSubwaySummary[,1:5] <- apply(dfSubwaySummary[,1:5], 2, as.numeric)

dfSubwaySummary$RidePerPop <- dfSubwaySummary$Rides/dfSubwaySummary$Population



# Insert continent
# ==================================================================================================================================================

continent <- list("Europe" = c("Turkey", "Netherlands", "Greece", "Spain", "Germany", "Italy", "Belgium", 
                              "Romania", "Hungary", "Denmark", "Ukraine", "United Kingdom", "Finland", 
                              "Russia", "Switzerland", "France", "Portugal", "Belarus", "Norway",
                              "Czech Republic", "Bulgaria", "Sweden", "Austria",  "Poland"),
                  "Asia" = c("Kazakhstan", "Azerbaijan", "India", "Thailand", "China", "South Korea", "United Arab Emirates",
                            "Japan", "Taiwan", "Malaysia", "Philippines", "Iran", "Saudi Arabia", "Singapore", "Uzbekistan",
                            "Georgia", "Armenia", "North Korea", "Korea"),
                  "Africa" = c("Algeria", "Egypt"),
                  "South America" = c("Brazil", "Argentina", "Venezuela",  "Peru", "Colombia", "Chile"),
                  "North America" = c("United States", "Mexico", "Canada", "Puerto Rico"),
                  "Central America" = c("Dominican Republic"))
continent <- lapply(continent, noAccentLowerCase)

dfSubwaySummary$continent <- NA
for(cont in names(continent)){
  dfSubwaySummary$continent[dfSubwaySummary$Country %in% continent[[cont]]] <- cont
}

rownames(dfSubwaySummary) <- locationWithAccent[rownames(dfSubwaySummary)] 
dfSubwaySummary$Country <- countryWithAccent[dfSubwaySummary$Country]

write.csv(dfSubwaySummary, "subway.csv")