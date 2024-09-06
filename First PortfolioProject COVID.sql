SELECT *
from PortfolioProject..CovidDeaths
order by population desc ;

--looking at total cases vs total deaths
SELECT location, date, total_deaths,total_cases , (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location='Algeria'
order by 2 asc;

--looking at total cases vs Population
--Shows the percentage of population that got covid
SELECT location, date, total_cases,population,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where location='Algeria'
order by 2 desc;
--SHOW Contries with the highest infection rate per population
SELECT location,Population,MAX(total_cases) AS HighestInfectionCount,MAX(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths 
--where location='Algeria'
Group by location,population
order by PercentPopulationInfected desc
--SHOW Contries with the highest death rate per population
SELECT location,MAX(total_deaths) AS HighestDeathCount,MAX(total_deaths/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths 
--where location='Algeria'
Group by location
order by DeathPercentage desc


--SHOW Contries with the highest death count per population
SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
from PortfolioProject..CovidDeaths 
--where location='Algeria'
where continent is not null
Group by location
order by TotalDeathCount desc

--lets group by continent
SELECT continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
from PortfolioProject..CovidDeaths 
--where location='Algeria'
where continent is not null
Group by continent
order by TotalDeathCount desc;

--GLOBAL Numbers

SELECT  sum(new_cases) as TotalCases ,SUM(cast(new_deaths as int)) as TotalDeaths , 
(SUM(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location='Algeria'
where continent is not null
--group by date
order by 1;

-- Looking at Total population vs Vaccination
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(INT, vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as TotalVac
--,(TotalVac/population)
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as  vac
 on  dea.location = vac.location
 and dea.date=vac.date
 where dea.continent is not null
 and dea.location='ALGERIA'
 order by 2,3;


 --CTE
 With PopvsVac(Continent,location,date, population,new_vaccinations,TotalVac)
 AS (
 SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(INT, vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as TotalVacc
--,(TotalVac/population)
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as  vac
 on  dea.location = vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select * ,(TotalVac/population)*100 as VaccPercentage
 from PopvsVac 


--Create view to store data for later vizualisation
Create View PercentPopulationVaccinated as 
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(INT, vac.new_vaccinations )) over (partition by dea.location order by dea.location,dea.date) as TotalVac
--,(TotalVac/population)
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as  vac
 on  dea.location = vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --and dea.location='ALGERIA'
 --order by 2,3;