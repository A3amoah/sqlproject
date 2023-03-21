
CREATE VIEW continents AS
select continent,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths1
where continent is not null
Group by continent
--order by TotalDeathCount desc

select* from
continents