-- Circuits where F1 races are held
USE Formula1
Go
CREATE TABLE dbo.dimCircuits(
	circuitId INT, --id
	circuitRef	VARCHAR(100), -- Reference name of circuit
	name VARCHAR(100), -- Actual Name of circuit
	location VARCHAR(100), -- City
	country VARCHAR(100), -- Country
	lat	DECIMAL(8,6), -- Lattitude
	lng	DECIMAL(9,6), -- Longtitude
	alt	FLOAT, -- Altitude
	url VARCHAR(3000) -- Wikipedia URL
	primary key (circuitId)
)

-- This table contains the points for each constructor after every race
CREATE TABLE dbo.Constructor_Results(
	constructorResultsId INT, -- Id
	raceId	INT, -- Id of race
	constructorId INT, -- Id of Constructor
	points	FLOAT, -- Points
	status VARCHAR(10) -- Status of Result
	primary key (constructorResultsId)
)

-- Final Standings of the constructor championship
CREATE TABLE dbo.Constructor_Standings(
	constructorStandingsId INT, -- Id
	raceId INT, -- Id of race
	constructorId INT, -- Id of Constructor
	points FLOAT, -- Points
	position INT, -- Final Position
	positionText VARCHAR(10), -- Final position in text
	wins INT -- Amount of wins
	primary key (constructorStandingsId)
)

-- Constructors in F1
CREATE TABLE dbo.dimConstructors(
	constructorId INT, -- Id
	constructorRef VARCHAR(200), -- Reference name of constructor
	name VARCHAR(150), -- Actual name of constructor
	nationality	VARCHAR(100), -- Country
	url VARCHAR(3000) -- URL for wikipedia for constructor
	primary key (constructorId)
)

-- Final standings of the driver's championship
CREATE TABLE dbo.Driver_Standings(
	driverStandingsId INT, -- Id
	raceId INT, -- Id of Race
	driverId INT, -- Id of Driver
	points FLOAT, -- Points
	position INT, -- Final Position
	positionText VARCHAR(10), -- Final position text
	wins INT -- Number of Wins
	primary key (driverStandingsId)
)

-- Drivers in F1
CREATE TABLE dbo.dimDrivers(
	driverId INT, -- Id
	driverRef VARCHAR(100), -- Reference name for driver
	number FLOAT, -- driver number
	code VARCHAR(3), -- 3 letter alphabet code of driver
	forename VARCHAR(50), -- First Name
	surname VARCHAR(50), -- Last Name
	dob DATE, -- Birthday
	nationality VARCHAR(100), -- Country	
	url VARCHAR(3000) -- Wikipedia URL of Driver
	primary key (driverId)
)

-- Lap Times in F1
CREATE TABLE dbo.Lap_Times(
	raceId INT, -- Id of Race
	driverId INT, -- Id of Driver
	lap INT, -- Current Lap
	position INT, -- Final Position
	time VARCHAR(100), -- Time of Current Lap
	milliseconds FLOAT -- Time in milliseconds
)

-- Pit Stops in F1
CREATE TABLE dbo.Pit_Stops(
	raceId INT, -- Id
	driverId INT, -- Id of driver
	stop INT, -- Stop Number
	lap INT, -- Lap Number
	time VARCHAR(100), -- Time of pit stop
	duration VARCHAR(100), -- Duration of pit stop
	milliseconds FLOAT -- Duration of pit stop in milliseconds
)

-- Qualifying in F1
CREATE TABLE dbo.Qualifying(
	qualifyId INT, -- Id
	raceId INT, -- Id of race
	driverId INT, -- Id of Driver
	constructorId INT, -- Id of Constructor
	number FLOAT, -- Car Number
	position INT, -- Final Position
	q1 VARCHAR(100), -- Q1 Time
	q2 VARCHAR(100), -- Q2 Time
	q3 VARCHAR(100) -- Q3 Time
	primary key (qualifyId)
)

-- Races in F1
CREATE TABLE dbo.Race_Info(
	raceId	INT, -- Id of race
	year INT, -- Year
	round INT, -- Round
	circuitId INT, -- Id of Circuit
	name VARCHAR(100), -- Name of Circuit
	date DATE, -- Date
	time VARCHAR(100), -- Time
	url VARCHAR(3000), -- Wikepedia URL of Race
	fp1_date DATE, -- Fp1 date
	fp1_time VARCHAR(100), -- Fp1 time
	fp2_date DATE, -- Fp2 date
	fp2_time VARCHAR(100), -- Fp2 time
	fp3_date DATE, -- Fp3 date
	fp3_time VARCHAR(100), -- Fp3 time
	quali_date DATE, -- Qualifying date
	quali_time VARCHAR(100), -- Qualifying time
	sprint_date DATE, -- Sprint date
	sprint_time VARCHAR(100) -- Sprint time
	primary key (raceId)
)

-- Results of F1 Races
CREATE TABLE dbo.Results (
	resultId INT, -- Id
	raceId	INT, -- Id of Race
	driverId INT, -- Id of Driver
	constructorId INT, -- Id of Constructor
	number FLOAT, -- Car Number
	grid INT, -- Position on Grid Start
	position FLOAT, -- Final Position
	positionText VARCHAR(10), -- Final position in text
	positionOrder INT, -- Final Rank
	points FLOAT, -- Points
	laps INT, -- Laps
	time VARCHAR(100), -- Time
	milliseconds FLOAT, -- Time in milliseconds
	fastestLap FLOAT, -- Lap Number of fastest lap
	rank FLOAT, -- Rank of fastest lap
	fastestLapTime VARCHAR(100), -- Lap time of fastest lap
	fastestLapSpeed FLOAT(24), -- Speed of Fastest lap
	statusId INT -- Id of Status
	primary key (resultId)
)

-- Seasons of F1
CREATE TABLE dbo.dimYear(
	Year INT, -- Year
	Url VARCHAR(3000) -- Wikipedia link to year
)

-- Results of Sprint Races
CREATE TABLE dbo.Sprint_Results(
	sprintResultId INT, -- Id
	raceId	INT, -- Id of Race
	driverId INT, -- Id of Driver
	constructorId INT, -- Id of Constructor
	number FLOAT, -- Car Number
	grid INT, -- Position on Grid
	position FLOAT, -- Final Position
	positionText VARCHAR(10), -- Final position in text
	positionOrder INT, -- Final Rank
	points FLOAT, -- Points
	laps INT, -- Laps
	time VARCHAR(100), -- Time
	milliseconds FLOAT, -- Time in milliseconds
	fastestLap FLOAT, -- Lap number of fastest lap
	fastestLapTime VARCHAR(100), -- Lap time of fastest lap
	statusId INT -- Id of Status
	primary key (sprintResultId)
)

-- Mapping of various statuses
CREATE TABLE dbo.dimStatus(
	statusId INT, -- Id
	status VARCHAR(60) -- Statuses such as Finished, Dq, Accident, Collision and so on
	primary key (statusId)
)