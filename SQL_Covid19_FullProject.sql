
/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/
SELECT COUNT(*) FROM CovidDeaths;
SELECT COUNT(*) FROM CovidVaccinations;

SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL 
AND continent != ''
ORDER BY 3, 4;

SELECT *
FROM CovidVaccinations
ORDER BY 3,4;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL 
AND continent != ''
ORDER BY 1,2;

-- Looking at Total cases vs Total Deaths
-- This shows the likelihood of dying if you contact covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM CovidDeaths
WHERE location like '%states%' AND continent != '' and continent is not null
ORDER BY 1,2;


-- Looking at Total cases vs Population
-- Show what percentage of population infected with Covid
SELECT location, date, total_cases, population, (total_cases/population) * 100 as PercentPopulationInfected 
FROM CovidDeaths
WHERE location like '%states%' and continent != '' and continent is not null
ORDER BY 1,2;

-- Looking at countries with highest infection rate compared to population

SELECT location, population,MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected 
FROM CovidDeaths
-- WHERE location like '%states%'
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC;

-- Showing countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From CovidDeaths
-- Where location like '%states%'
WHERE continent IS NOT NULL 
AND continent != ''
Group by Location
order by TotalDeathCount desc;

-- Breaking Things by Continent
-- Showing the continents with the highest death counts per population

Select continent, MAX(Total_deaths) as TotalDeathCount
From CovidDeaths
WHERE continent != ''
Group by continent
order by TotalDeathCount desc;

-- Global Numbers
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent != '' 
order by 1,2;


-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
ORDER BY 2,3;


--  USE CTE    

WITH PopvsVac(Continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
)

SELECT *,(RollingPeopleVaccinated / population) * 100
FROM PopvsVac;


-- TEMP TABLE

DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
date DATE,
population BIGINT,
new_vaccinations BIGINT,
RollingPeopleVaccinated BIGINT
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != '';

SELECT *,(RollingPeopleVaccinated / population) * 100
FROM PercentPopulationVaccinated;


-- Creating view to store data for later visualization.

-- View 1: All Covid Deaths Data
CREATE VIEW vw_CovidDeathsClean AS
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL 
AND continent != '';

-- View 2: All Covid Vaccinations Data
CREATE VIEW vw_CovidVaccinationsClean AS
SELECT *
FROM CovidVaccinations;

-- View 3: Key Columns Only
CREATE VIEW vw_KeyCovidStats AS
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL 
AND continent != '';

-- View 4: Death Percentage in United States
CREATE VIEW vw_USDeathPercentage AS
SELECT location, date, total_cases, total_deaths, 
(total_deaths/total_cases) * 100 as DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%states%' 
AND continent != '' 
AND continent IS NOT NULL;

-- View 5: Infection Rate vs Population in United States
CREATE VIEW vw_USInfectionRate AS
SELECT location, date, total_cases, population, 
(total_cases/population) * 100 as PercentPopulationInfected 
FROM CovidDeaths
WHERE location LIKE '%states%' 
AND continent != '' 
AND continent IS NOT NULL;

-- View 6: Countries with Highest Infection Rate
CREATE VIEW vw_GlobalInfectionRate AS
SELECT location, population,
MAX(total_cases) AS HighestInfectionCount, 
MAX((total_cases/population)) * 100 as PercentPopulationInfected 
FROM CovidDeaths
GROUP BY location, population;

-- View 7: Countries with Highest Death Count
CREATE VIEW vw_CountryDeathCount AS
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL 
AND continent != ''
GROUP BY location;

-- View 8: Continents with Highest Death Count
CREATE VIEW vw_ContinentDeathCount AS
SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent != ''
GROUP BY continent;

-- View 9: Global Death Percentage
CREATE VIEW vw_GlobalDeathPercentage AS
SELECT 
SUM(new_cases) as total_cases, 
SUM(new_deaths) as total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent != '';

-- View 10: Global Vaccination Progress
CREATE VIEW vw_PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != '';


-- Queries used for Tableau Project

-- Query 1: Global Numbers
SELECT 
    SUM(new_cases) as total_cases, 
    SUM(new_deaths) as total_deaths, 
    SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL 
AND continent != ''
ORDER BY 1,2;

-- Query 2: Death Count by Continent
SELECT location, SUM(new_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = '' 
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Query 3: Infection Rate by Country
SELECT location, population, 
MAX(total_cases) as HighestInfectionCount,  
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Query 4: Infection Rate by Country and Date
SELECT location, population, date, 
MAX(total_cases) as HighestInfectionCount,  
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;


-- Query 5 — Vaccination vs Deaths Over Time
SELECT 
    dea.location,
    dea.date,
    dea.new_deaths,
    dea.total_deaths,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER(
        PARTITION BY dea.location 
        ORDER BY dea.date) as RollingVaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
AND dea.continent != ''
ORDER BY 1,2;











