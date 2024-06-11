Select *
From PortifolioProject..CovidDeaths
Where continent is not null



----Selecting data I am going to use

Select Location, date, total_cases, new_cases, total_deaths, population
From PortifolioProject..CovidDeaths
Where continent is not null

order by 1,2


--Looking Total cases vs total deaths 

-- shows likehood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (cast(total_deaths as float )/cast(total_cases as float))*100 as DeathsPercentage 
From PortifolioProject..CovidDeaths
Where location like '%Mozambique'
And continent is not null

order by 1,2

-- Looking at population vs total cases
-- Shows what percentage of people got covid

Select Location, date, population, total_cases, (cast(total_cases as float)/ cast(population as float))*100 as PercentaOfPopulation
From PortifolioProject..CovidDeaths
--Where location like '%Mozambique'
where continent is not null
order by 1,2


-- Looking at countries with Highest infection Rate compared to Population 

Select Location, population, Max(total_cases) as HighestInfectOnCountry, Max(cast(total_cases as float)/cast(population as float)) as PercentageOfPopulationInfected
From PortifolioProject..CovidDeaths
--Where location like '%Mozambique'
Where continent is not null
Group by Location, Population
order by PercentageOfPopulationInfected desc


 -- Showing  Country with Highest Death Count Per Population

 Select Location, Max(cast(total_deaths as int)) as TotalDeathsCount
 From PortifolioProject..CovidDeaths
 where continent is not null
 group by Location 
 Order by TotalDeathsCount desc

  
 -- LET'S thtsBREAK THINGS BY CONTINENT
 -- Showing the continent with the highest death count per population

 Select continent, Max(cast(total_deaths as int )) as TotalDeathCount
 From PortifolioProject..CovidDeaths
 Where continent is not null
 Group by Continent
 Order by TotalDeathCount desc


 -- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, 
	SUM(Cast(new_deaths as int))/SUM(NullIf(New_Cases, 0) )*100 as DeathPercentage
From PortifolioProject..CovidDeaths
Where continent is not null
group by date 
order by 1,2



 --Total cases, total deaths and total percentage of the globe
  
Select  SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, 
SUM(Cast(new_deaths as int))/SUM(NullIf(New_Cases, 0) )*100 as DeathPercentage
 From PortifolioProject..CovidDeaths
 Where continent is not null 
 order by 1,2



 Select *
 from PortifolioProject..CovidVacination


 -- JOIN of the covidDeaths Table and CovidVacination Tables 
Select * 
From PortifolioProject..CovidDeaths dea
Join CovidVacination vac
	On dea.location = vac.location
	and dea.date = vac.date


--Looking at total vaccinattion Vs Population

-- Using CTE
With PopulationVSVacinated  (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order By dea.location,
dea.Date ROWS UNBOUNDED PRECEDING) As RollingPeopleVaccinated
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVacination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not Null
--and dea.location like '%Mozambique'
--Order By   1,2
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercetageOfVaccinatedPeo
From PopulationVSVacinated



-- TEMP TABLE

DROP Table if exists #PercetagePeopleVaccinated
Create Table #PercetagePeopleVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercetagePeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order By dea.location,
dea.Date ROWS UNBOUNDED PRECEDING) As RollingPeopleVaccinated
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVacination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not Null
--and dea.location like '%Mozambique'
--Order By   1,2

Select *, (RollingPeopleVaccinated/Population)*100 as PercetageOfVaccinatedPeo
From #PercetagePeopleVaccinated


-- Creating View to store data later visualization

Create view PercetagePeopleVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order By dea.location,
dea.Date ROWS UNBOUNDED PRECEDING) As RollingPeopleVaccinated
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVacination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not Null
--and dea.location like '%Mozambique'
--Order By   1,2


Select *
From PercetagePeopleVaccinated






 