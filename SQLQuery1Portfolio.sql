
-- First, I take a look at the tables.
select *
from PortfolioProject..emissions
order by Entery

select *
from PortfolioProject..population
order by Entery

-- I correct the name of the columns in Design window.

-- Column Continent is not filled correctly, so I Drop it.
ALTER TABLE PortfolioProject..emissions DROP COLUMN Continent


-- We can see that some enteries in the population table have duplicates. These duplicates
-- must be removed. In order to do that, I use CTE.
WITH CTE AS (
    SELECT Entery, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                Entery
            ORDER BY 
                Entery
        ) row_num
     FROM 
        PortfolioProject..population
)
DELETE FROM CTE
WHERE row_num > 1


-- The time period starts from 1949. I only investigate the data after 2000.
DELETE FROM PortfolioProject..emissions
WHERE Year < 2000

DELETE FROM PortfolioProject..population
WHERE Year < 2000


-- Deleting rows that the value of CO2 emission for them is NULL.
DELETE FROM PortfolioProject..emissions
WHERE [CO2 emissions per capita] is NULL 


-- Checking the average CO2 emission for each country between 2000 until 2021.
SELECT Country, AVG([CO2 emissions per capita]) AS AverageOfEmission
FROM PortfolioProject..emissions
GROUP BY Country 
ORDER BY AverageOfEmission


-- Checking the average CO2 emission for each year between 2000 until 2021 for all countries.
SELECT Year, AVG([CO2 emissions per capita]) AS AnnualAverage
FROM PortfolioProject..emissions
GROUP BY Year 
ORDER BY AnnualAverage


-- The lowest CO2 emission was in which country and at what year.
SELECT Country, Year, [CO2 emissions per capita]
FROM PortfolioProject..emissions
ORDER BY [CO2 emissions per capita]


-- The highest CO2 emission was in which country and at what year.
SELECT Country, Year, [CO2 emissions per capita]
FROM PortfolioProject..emissions
ORDER BY [CO2 emissions per capita] DESC


-- We can check the data for an specific year or an specific country.
SELECT *
FROM PortfolioProject..emissions
WHERE Country LIKE '%Spain%'


-- The whole amount of CO2 emissions in the world from 2000 to 2021
SELECT SUM([CO2 emissions per capita]) AS SumEmissions
FROM PortfolioProject..emissions
-- This sum is 26450.3625760971


-- Checking the European countries, their CO2 emissions and their share of the world emissions. 
SELECT Country,
CASE
	WHEN Country IN ('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Republic of Cyprus', 'Czech Republic',
			'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy',
			'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Holland', 'Poland', 'Portugal', 'Romania',
			'Slovakia', 'Slovenia', 'Spain', 'Sweden') THEN 'Yes'
	ELSE 'No'
END AS EuropeanUnion
FROM PortfolioProject..emissions

SELECT SUM ([CO2 emissions per capita]) AS EuropeanUnionEmissions,
		SUM (([CO2 emissions per capita])/26450.3625760971)*100 AS EuropeanUnionShare
FROM PortfolioProject..emissions
WHERE Country IN ('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Republic of Cyprus', 'Czech Republic',
			'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy',
			'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Holland', 'Poland', 'Portugal', 'Romania',
			'Slovakia', 'Slovenia', 'Spain', 'Sweden')
-- We can see that the European Union countries produced 16 percent of the global CO2 emissions.


-- In the Population table, there is a column for GDP per capita. I join the tables and see
-- the Average of emissions and GDP for each country.
SELECT emissions.Country, AVG([CO2 emissions per capita]) AS AverageEmissios,
	AVG([GDP per capita]) AS AverageGDP
From PortfolioProject..emissions
JOIN PortfolioProject..population
	ON emissions.Entery = population.Entery
GROUP BY Country

