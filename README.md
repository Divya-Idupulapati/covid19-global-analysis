# COVID-19 Global Data Analysis

## Overview
This project explores global COVID-19 data to uncover trends in infection rates, death counts, and vaccination progress across countries and continents. The goal was to use SQL for data exploration and Tableau for building an interactive dashboard that makes the numbers easy to understand.

---

## Tools Used
- **SQL (MySQL)** — data exploration and analysis
- **Excel** — raw data storage and intermediate outputs
- **Tableau** — interactive dashboard and visualizations

---

## Dataset
- **CovidDeaths.xlsx** — daily COVID-19 case and death records by country
- **CovidVaccinations.xlsx** — vaccination progress, testing rates, and demographic data by country
- Source: [Our World in Data](https://ourworldindata.org/covid-deaths)
- Scale: 150M+ global records across two relational tables

---

## What I Analyzed
- Death percentage by country (likelihood of dying if infected)
- Infection rate as a percentage of population
- Countries with the highest infection and death counts
- Continent-level death totals
- Rolling vaccination counts vs population over time

---

## SQL Techniques Used
- Joins
- CTEs (Common Table Expressions)
- Temp Tables
- Window Functions
- Aggregate Functions
- Views
- Data Type Conversion

---

## Key Findings
- Global death percentage from COVID-19 was approximately **2.11%**
- Europe recorded the highest continent-level death count
- Andorra had the highest infection rate relative to its population
- Rolling vaccination data showed steady global progress after early 2021

---

## Dashboard
The Tableau dashboard visualizes:
- Global infection rates by country (map view)
- Death counts by continent (bar chart)
- Percent population infected over time (line chart)
- Global summary KPIs (total cases, total deaths, death percentage)

> **Note:** Tableau dashboard file (`.twb`) is included in this repository. Data files need to be connected locally to view the live dashboard.

---

## How to Run
1. Import `CovidDeaths.xlsx` and `CovidVaccinations.xlsx` into MySQL
2. Run `SQL_Covid19_FullProject.sql` to execute all queries
3. Open `Covid_TableauFullProject.twb` in Tableau Desktop and connect to your data source

---

## Author
**Divya Idupulapati**
- Email: idupulapatidivya07@gmail.com
