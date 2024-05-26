-- Circuits where F1 races are held
USE Formula1
Go
DROP TABLE dbo.dimCircuits

-- This table contains the points for each constructor after every race
DROP TABLE dbo.Constructor_Results

-- Final Standings of the constructor championship
DROP TABLE dbo.Constructor_Standings

-- Constructors in F1
DROP TABLE dbo.dimConstructors

-- Final standings of the driver's championship
DROP TABLE dbo.Driver_Standings

-- Drivers in F1
DROP TABLE dbo.dimDrivers

-- Lap Times in F1
DROP TABLE dbo.Lap_Times

-- Pit Stops in F1
DROP TABLE dbo.Pit_Stops

-- Qualifying in F1
DROP TABLE dbo.Qualifying

-- Races in F1
DROP TABLE dbo.Race_Info

-- Results of F1 Races
DROP TABLE dbo.Results

-- Seasons of F1
DROP TABLE dbo.dimYear

-- Results of Sprint Races
DROP TABLE dbo.Sprint_Results

-- Mapping of various statuses
DROP TABLE dbo.dimStatus