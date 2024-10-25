select *
from [PortfolioProject1].[dbo].[CovidDeaths$]
order by 3,4
--select *
--from [PortfolioProject1].[dbo].[CovidVaccinations$]
--order by 3,4

-- select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject1..CovidDeaths$
order by 1,2

-- looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortfolioProject1..CovidDeaths$
where location like '%states%'
order by 1,2

--looking at total cases vs population
--show what percentage of population got Covid
select location, date, total_cases, population, (total_cases/population)*100 as cases_percentage
from PortfolioProject1..CovidDeaths$
where location like '%states%'
order by 1,2

-- looking at countries with hightest  infection rate compared to population
select location, population,max(total_cases) as HighesIinfectionCount, max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject1..CovidDeaths$
--where location like '%states%'
group by location, population
order by 1,2

--showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

--showing contintentss with the highest death count per population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- global numbers
select date, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,( sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
from PortfolioProject1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2


-- looking at total population cs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
from [PortfolioProject1].[dbo].[CovidDeaths$] dea
join [PortfolioProject1].[dbo].[CovidVaccinations$] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use cte

with PopvsVac( Continent, location, date, population,new_vaccinations, RollingPeopleVaccinated )
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated 
from [PortfolioProject1].[dbo].[CovidDeaths$] dea
join [PortfolioProject1].[dbo].[CovidVaccinations$] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac


-- temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)
insert into  #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated 
from [PortfolioProject1].[dbo].[CovidDeaths$] dea
join [PortfolioProject1].[dbo].[CovidVaccinations$] vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated 
from [PortfolioProject1].[dbo].[CovidDeaths$] dea
join [PortfolioProject1].[dbo].[CovidVaccinations$] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
SELECT OBJECT_ID('PercentPopulationVaccinated', 'P') AS ObjectID;
select *
from PercentPopulationVaccinated