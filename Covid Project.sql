select * from coviddeaths;

# select * from covidvaccinations;

# select data to be used

select * from coviddeaths;

select Location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by Location;

# total cases vs total deaths
# shows the likelihood of dying if you contract covid in your country.
select Location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as deathpercentage
from coviddeaths
where Location like 'Ireland'
order by Location;

# Look at total cases vs population
# shows what percentage of population got covid
select Location, date, population, total_cases, 
(total_cases/population)*100 as casespercentage
from coviddeaths
where Location like 'Ireland'
order by Location;

# look at countries with highest infection rate compared to population
select Location, population, max(total_cases) as HighestInfectionCount, 
max((total_cases/population))*100 as casespercentage
from coviddeaths
group by Location, population
order by casespercentage desc;

# show countries with highest death count per population
select Location, max(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent != ''
group by Location
order by TotalDeathCount desc;

# exploring by continent
# some locations were listed as continents, and had the continent column blank
# showing continents with highest death count
select continent, max(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent != ''
group by continent
order by TotalDeathCount desc;

# Global numbers
# total cases vs total deaths
select str_to_date(date, '%d/%m/%Y') as date, sum(new_cases), 
sum(new_deaths),
sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent != ''
group by date
order by date;

#remove date
select sum(new_cases), 
sum(new_deaths),
sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from coviddeaths
where continent != ''
order by 1, 2;

# explore vaccination dataset
select * from covidvaccinations;

#join tables together
select * from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date;

# look at total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent != ''
order by 2,3;

#create rolling count of people vaccinated per country
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent != ''
order by 2,3;

# calculate rolling total vaccinated per population
# create temp table
drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date nvarchar(255),
Population numeric, 
New_vaccinations nvarchar(255),
RollingPeopleVaccinated numeric);

Insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent != ''
order by 2,3;

select *, (RollingPeopleVaccinated/Population)*100
from PercentPopulationVaccinated;

# create views for later visualisations
create view PercentPopulationVac as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent != ''
;

select * from percentpopulationvaccinated;