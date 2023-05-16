# 1. Death Percentage 

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent != '' 
order by 1,2;

# 2. Deaths per Continent

Select location, SUM(new_deaths) as TotalDeathCount
From CovidDeaths
Where continent = ''
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;


# 3. Country Infection Count & Rate

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;


# 4. Infections Per Day

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc;
