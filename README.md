metro systems around the world 
==============================================

Introduction
-------------

The idea of this project is to understand comparisons between metro systems in different cities. [Like this from BBC Brasil](http://www.bbc.co.uk/portuguese/videos_e_fotos/2014/01/140102_china_metro_rp.shtml).

Folders
----------

The *table* folder contains a code in *R* that extracts information from Wikipedia about the metro system of different cities. This code will write a [csv table](https://github.com/celacanto/metro-systems-around-the-world/blob/master/table/subway.csv) with the summary informations of the metros systems.

The *plots* folder contain a *R* codes to plot the data. 

Data on the CSV table
----------------------

The data on [CSV table](https://github.com/celacanto/metro-systems-around-the-world/blob/master/table/subway.csv) are grouped by cities. Data on subway systems were obtained from two Wikipedia tables ([List of Metro Systems](http://en.wikipedia.org/wiki/List_of_metro_systems) and [Metro systems by annual passenger rides](http://en.wikipedia.org/wiki/Metro_systems_by_annual_passenger_rides)). Were only considered systems that were present in both articles.

Population data for each city were mostly obtained from [MaxMind](http://www.maxmind.com/en/web_services_omni)

Here's a summary of the meaning of the not self explanatory columns:

* **Year.opened** -- Year in which the first  systems considered was opened in the city
* **Rides** -- Rides sum of the systems considered for the city in one year.
* **System.length** -- Length sum of all systems considered for the city.
* **Stations** -- Sum of the number of stations of all the systems considered for the city.
* **Systems** -- The city's systems considered.
* **RidePerPop** -- Rides/Population

Plots
-----------------------

Now there is two type of plots:

1. [System Lenght versus Year of System Oppening](https://github.com/celacanto/metro-systems-around-the-world/blob/master/plots/yearOpenXlength.R)
2. [Rides versus Population](https://github.com/celacanto/metro-systems-around-the-world/blob/master/plots/ridesXpopulation.R) 


The first one is what I did to make some sense from articles [like this one](http://www.bbc.co.uk/portuguese/noticias/2013/01/130111_metro_comparacao_sp_londres_rw.shtml). The other is a an attempt to also consider the size of the city in comparing the metro. The idea of using as a metric number of trips divided by the population has been proposed by [Rafael S. Calsaverini](https://twitter.com/rcalsaverini/status/422701192045924352). Both codes make a version with all the cities and other versions where the different continents are highlighted.
