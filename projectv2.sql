select *
from PortfolioProject..CovidDeaths
order by 3, 4


--select *
--from PortfolioProject..CovidVaccinations
--order by 3, 4


-- select data that we are going to use

select Location,date, total_cases, new_cases, total_deaths, population_density
from PortfolioProject..CovidDeaths
order by 1, 2

--looking at Total Cases vs Total Deaths
--shows the likelihood of dying if you contract covid
select Location,date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1
order by 1, 2

select location 
from PortfolioProject..CovidDeaths1
where location = 'Asia' 
select DISTINCT(location)
from PortfolioProject..CovidDeaths1

--select DISTINCT(location)
--from PortfolioProject..CovidDeaths


 --looking at Total Cases vs Total Deaths
select Location,date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1
where location like '%africa%'
order by 1, 2


select Location,date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1
where location like '%Brazil%'
order by 1, 2

--looking at the total cases vs population
--shows what percentage of population got covid
select Location, date, total_cases,  population_density, (total_deaths/population_density)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1
where location like '%africa%'
order by 1, 2

--looking at the countries with the highest infection rate compared to population
select Location, MAX(total_cases) as HighestInfectionCount,  population_density--,MAX( (total_deaths/population_density))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths1
--where location like '%africa%'
group by location, population_density
order by HighestInfectionCount desc

--show countries with the highest death counts per population
select Location,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths1
where continent is not null
Group by location
order by TotalDeathCount desc


---Lets break things by continent
select continent,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths1
where continent is not null
Group by continent
order by TotalDeathCount desc


--continent with the highest death count per population
select continent,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths1
where continent is not null
Group by continent
order by TotalDeathCount desc

--global numbers
select  SUM(total_cases) as total_cases,  SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1
--where location like '%Brazil%'
where continent is not null
--Group by date
order by 1, 2


---looking at toatl population vs vaccinations
select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) 
OVER (Partition by dea.location order by dea.location) as RollingPeopleVaccinated--,RollingPeopleVaccinated/
from PortfolioProject..CovidDeaths1 dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
--and dea.date = CAST(vac.date AS datetime)
where dea.continent is not null
order by 1,2,3

--using CTE
with popvsvac (continent,location,Date,Population_density,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) 
OVER (Partition by dea.location order by dea.location) as RollingPeopleVaccinated--,RollingPeopleVaccinated/
from PortfolioProject..CovidDeaths1 dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
--and dea.date = CAST(vac.date AS datetime)
where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/Population_density)*100
from popvsvac

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population_density numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	--and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population_density)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulation as
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	--and dea.date = vac.date
where dea.continent is not null 