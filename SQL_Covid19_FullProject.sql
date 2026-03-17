SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'secure_file_priv';
CREATE DATABASE IF NOT EXISTS covid_data;
USE covid_data;



CREATE TABLE CovidDeaths (
  
    iso_code                        VARCHAR(10),        -- e.g. AFG, USA
    continent                       VARCHAR(50),        -- e.g. Asia, Europe
    location                        VARCHAR(100),       -- e.g. Afghanistan
    date                            DATE,               -- stored as DATE after conversion

   
    total_cases                     BIGINT,             -- cumulative total cases
    population                      BIGINT,             -- country population
    new_cases                       INT,                -- daily new cases
    new_cases_smoothed              FLOAT,              -- 7-day smoothed
    
   
    total_deaths                    INT,                -- cumulative deaths
    new_deaths                      INT,                -- daily new deaths
    new_deaths_smoothed             FLOAT,              -- 7-day smoothed


    total_cases_per_million         FLOAT,
    new_cases_per_million           FLOAT,
    new_cases_smoothed_per_million  FLOAT,
    total_deaths_per_million        FLOAT,
    new_deaths_per_million          FLOAT,
    new_deaths_smoothed_per_million FLOAT,


    reproduction_rate               FLOAT,              -- R value
    icu_patients                    INT,
    icu_patients_per_million        FLOAT,
    hosp_patients                   INT,
    hosp_patients_per_million       FLOAT,

   
    weekly_icu_admissions               FLOAT,
    weekly_icu_admissions_per_million   FLOAT,
    weekly_hosp_admissions              FLOAT,
    weekly_hosp_admissions_per_million  FLOAT
);


CREATE TABLE CovidVaccinations (
    
    iso_code                                VARCHAR(10),
    continent                               VARCHAR(50),
    location                                VARCHAR(100),
    date                                    DATE,


    new_tests                               INT,
    total_tests                             BIGINT,
    total_tests_per_thousand                FLOAT,
    new_tests_per_thousand                  FLOAT,
    new_tests_smoothed                      FLOAT,
    new_tests_smoothed_per_thousand         FLOAT,
    positive_rate                           FLOAT,          -- e.g. 0.05 = 5%
    tests_per_case                          FLOAT,
    tests_units                             VARCHAR(50),    -- e.g. 'people tested'

   
    total_vaccinations                      BIGINT,
    people_vaccinated                       BIGINT,
    people_fully_vaccinated                 BIGINT,
    new_vaccinations                        INT,
    new_vaccinations_smoothed               FLOAT,
    total_vaccinations_per_hundred          FLOAT,
    people_vaccinated_per_hundred           FLOAT,
    people_fully_vaccinated_per_hundred     FLOAT,
    new_vaccinations_smoothed_per_million   FLOAT,

    
    stringency_index                        FLOAT,          -- 0-100 policy strictness
    population_density                      FLOAT,          -- per sq km
    median_age                              FLOAT,
    aged_65_older                           FLOAT,          -- % of population
    aged_70_older                           FLOAT,          -- % of population
    gdp_per_capita                          DECIMAL(12,3),  -- USD
    extreme_poverty                         FLOAT,          -- % below poverty line
    cardiovasc_death_rate                   FLOAT,
    diabetes_prevalence                     FLOAT,          -- % of population
    female_smokers                          FLOAT,          -- % of females
    male_smokers                            FLOAT,          -- % of males
    handwashing_facilities                  FLOAT,          -- % with access
    hospital_beds_per_thousand              FLOAT,
    life_expectancy                         FLOAT,          -- years
    human_development_index                 FLOAT           -- 0 to 1
);


LOAD DATA LOCAL INFILE '/private/tmp/CovidDeaths.csv'
INTO TABLE CovidDeaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    iso_code, continent, location, @date,
    @total_cases, @population, @new_cases, @new_cases_smoothed,
    @total_deaths, @new_deaths, @new_deaths_smoothed,
    @total_cases_per_million, @new_cases_per_million, @new_cases_smoothed_per_million,
    @total_deaths_per_million, @new_deaths_per_million, @new_deaths_smoothed_per_million,
    @reproduction_rate,
    @icu_patients, @icu_patients_per_million,
    @hosp_patients, @hosp_patients_per_million,
    @weekly_icu_admissions, @weekly_icu_admissions_per_million,
    @weekly_hosp_admissions, @weekly_hosp_admissions_per_million
)
SET
    date                                = STR_TO_DATE(@date, '%m/%d/%y'),
    total_cases                         = NULLIF(@total_cases, ''),
    population                          = NULLIF(@population, ''),
    new_cases                           = NULLIF(@new_cases, ''),
    new_cases_smoothed                  = NULLIF(@new_cases_smoothed, ''),
    total_deaths                        = NULLIF(@total_deaths, ''),
    new_deaths                          = NULLIF(@new_deaths, ''),
    new_deaths_smoothed                 = NULLIF(@new_deaths_smoothed, ''),
    total_cases_per_million             = NULLIF(@total_cases_per_million, ''),
    new_cases_per_million               = NULLIF(@new_cases_per_million, ''),
    new_cases_smoothed_per_million      = NULLIF(@new_cases_smoothed_per_million, ''),
    total_deaths_per_million            = NULLIF(@total_deaths_per_million, ''),
    new_deaths_per_million              = NULLIF(@new_deaths_per_million, ''),
    new_deaths_smoothed_per_million     = NULLIF(@new_deaths_smoothed_per_million, ''),
    reproduction_rate                   = NULLIF(@reproduction_rate, ''),
    icu_patients                        = NULLIF(@icu_patients, ''),
    icu_patients_per_million            = NULLIF(@icu_patients_per_million, ''),
    hosp_patients                       = NULLIF(@hosp_patients, ''),
    hosp_patients_per_million           = NULLIF(@hosp_patients_per_million, ''),
    weekly_icu_admissions               = NULLIF(@weekly_icu_admissions, ''),
    weekly_icu_admissions_per_million   = NULLIF(@weekly_icu_admissions_per_million, ''),
    weekly_hosp_admissions              = NULLIF(@weekly_hosp_admissions, ''),
    weekly_hosp_admissions_per_million  = NULLIF(@weekly_hosp_admissions_per_million, '');

LOAD DATA LOCAL INFILE '/private/tmp/CovidVaccinations.csv'
INTO TABLE CovidVaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    iso_code, continent, location, @date,
    @new_tests, @total_tests, @total_tests_per_thousand, @new_tests_per_thousand,
    @new_tests_smoothed, @new_tests_smoothed_per_thousand,
    @positive_rate, @tests_per_case, tests_units,
    @total_vaccinations, @people_vaccinated, @people_fully_vaccinated,
    @new_vaccinations, @new_vaccinations_smoothed,
    @total_vaccinations_per_hundred, @people_vaccinated_per_hundred,
    @people_fully_vaccinated_per_hundred, @new_vaccinations_smoothed_per_million,
    @stringency_index, @population_density, @median_age,
    @aged_65_older, @aged_70_older, @gdp_per_capita,
    @extreme_poverty, @cardiovasc_death_rate, @diabetes_prevalence,
    @female_smokers, @male_smokers, @handwashing_facilities,
    @hospital_beds_per_thousand, @life_expectancy, @human_development_index
)
SET
    date                                    = STR_TO_DATE(@date, '%m/%d/%y'),
    new_tests                               = NULLIF(@new_tests, ''),
    total_tests                             = NULLIF(@total_tests, ''),
    total_tests_per_thousand                = NULLIF(@total_tests_per_thousand, ''),
    new_tests_per_thousand                  = NULLIF(@new_tests_per_thousand, ''),
    new_tests_smoothed                      = NULLIF(@new_tests_smoothed, ''),
    new_tests_smoothed_per_thousand         = NULLIF(@new_tests_smoothed_per_thousand, ''),
    positive_rate                           = NULLIF(@positive_rate, ''),
    tests_per_case                          = NULLIF(@tests_per_case, ''),
    total_vaccinations                      = NULLIF(@total_vaccinations, ''),
    people_vaccinated                       = NULLIF(@people_vaccinated, ''),
    people_fully_vaccinated                 = NULLIF(@people_fully_vaccinated, ''),
    new_vaccinations                        = NULLIF(@new_vaccinations, ''),
    new_vaccinations_smoothed               = NULLIF(@new_vaccinations_smoothed, ''),
    total_vaccinations_per_hundred          = NULLIF(@total_vaccinations_per_hundred, ''),
    people_vaccinated_per_hundred           = NULLIF(@people_vaccinated_per_hundred, ''),
    people_fully_vaccinated_per_hundred     = NULLIF(@people_fully_vaccinated_per_hundred, ''),
    new_vaccinations_smoothed_per_million   = NULLIF(@new_vaccinations_smoothed_per_million, ''),
    stringency_index                        = NULLIF(@stringency_index, ''),
    population_density                      = NULLIF(@population_density, ''),
    median_age                              = NULLIF(@median_age, ''),
    aged_65_older                           = NULLIF(@aged_65_older, ''),
    aged_70_older                           = NULLIF(@aged_70_older, ''),
    gdp_per_capita                          = NULLIF(@gdp_per_capita, ''),
    extreme_poverty                         = NULLIF(@extreme_poverty, ''),
    cardiovasc_death_rate                   = NULLIF(@cardiovasc_death_rate, ''),
    diabetes_prevalence                     = NULLIF(@diabetes_prevalence, ''),
    female_smokers                          = NULLIF(@female_smokers, ''),
    male_smokers                            = NULLIF(@male_smokers, ''),
    handwashing_facilities                  = NULLIF(@handwashing_facilities, ''),
    hospital_beds_per_thousand              = NULLIF(@hospital_beds_per_thousand, ''),
    life_expectancy                         = NULLIF(@life_expectancy, ''),
    human_development_index                 = NULLIF(@human_development_index, '');

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











