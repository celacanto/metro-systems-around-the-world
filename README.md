metro systems around the world 
==============================================

Introduction
-------------

The idea of this project is to understand comparisons between metro systems in different cities. [Like this from BBC Brasil](http://www.bbc.co.uk/portuguese/videos_e_fotos/2014/01/140102_china_metro_rp.shtml). The idea of ​​using as a metric number of trips divided by the population has been proposed by [Rafael S. Calsaverini](https://twitter.com/rcalsaverini/status/422701192045924352).

Files
----------

The *table* folder contains a code in *R* that extracts information from Wikipedia about the metro system of different cities. Also extracts information about city population from two tables obtained at http://dev.maxmind.com. This code will write a csv table with the summary of these informations.

The *plots* folder contain a *R* code that plots the population against the the metros rides in each city. Different plots highlight different continent. 

Data
----------

The data are grouped by cities. Data on subway systems were obtained from two tables from ([List of Metro Systems](http://en.wikipedia.org/wiki/List_of_metro_systems), and [Metro systems by annual passenger rides](http://en.wikipedia.org/wiki/Metro_systems_by_annual_passenger_rides). Were only considered systems that were present in both articles.

Population data for each city were mostly obtained from [MaxMind](http://www.maxmind.com/en/web_services_omni)

Here's a summary of the meaning of the not self explanatory columns of the [CSV table](https://github.com/celacanto/metro-systems-around-the-world/blob/master/table/subway.csv):

* **Year.opened** -- Year in which the first  systems considered was opened in the city
* **Rides** -- Rides sum of the systems considered for the city in one year.
* **System.length** -- Length sum of all systems considered for the city.
* **Stations** -- Sum of the number of stations of all the systems considered for the city.
* **Systems** -- The city's systems considered.
* **RidePerPop** -- Rides/Population
