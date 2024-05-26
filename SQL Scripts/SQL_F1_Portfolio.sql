-- PORTFOLIO PROJECT F1 Database
-- Previously, imported the data using SSIS into SSMS
-- In this portion will explore the data and create relevant tables and views to be exported into powerBI for visualization purposes. We will do the data transformations here at the source level so less compute time in POWER BI

-- FORMULA 1 SQL Data Exploration
SELECT * FROM Constructor_Results
SELECT * FROM Constructor_Standings
SELECT * FROM dimCircuits -- List of all circuits, already a dimension table
SELECT * FROM dimConstructors-- List of all constructors that have ever been in F1
SELECT * FROM dimDrivers -- Lists all drivers, current drivers have driver number
SELECT * FROM dimStatus -- Shows finish status, can be dnfs, dnq, or how many laps behind
SELECT * FROM dimYear -- Shows the years of each f1 season
SELECT * FROM Driver_Standings -- Shows finish position for drivers based on race id, only shows drivers that earned points
SELECT * FROM Lap_Times -- Shows laptime for each race and driver
SELECT * FROM Pit_Stops -- Shows pitstop information for each driver
SELECT * FROM Qualifying -- Shows qualifying times for each race
SELECT * FROM Race_Info -- Shows race info, start times for sessions, name of the race, the date and race id. Can get rid of session times as only recent years have data for these
SELECT * FROM Results -- Shows the results of the race
SELECT * FROM Sprint_Results -- Shows the results of the sprints

-- Starting with some data cleaning
-- Dropping columns that are unnecessary as we do not need to import them to PowerBI (Better practice is to not import them during the SSIS process but removing them now, if needed later, it is better to create alternate tables or views if not changing data in view)
ALTER TABLE Constructor_Results DROP COLUMN status
ALTER TABLE Constructor_Standings DROP COLUMN positionText
ALTER TABLE dimCircuits DROP COLUMN lat,lng,alt,url
ALTER TABLE dimConstructors DROP COLUMN url
ALTER TABLE dimDrivers DROP COLUMN url
ALTER TABLE dimYear DROP COLUMN url
ALTER TABLE Driver_Standings DROP COLUMN positionText
ALTER TABLE Race_Info DROP COLUMN url, fp1_date, fp1_time, fp2_date, fp2_time, fp3_date, fp3_time, quali_date, quali_time, sprint_date, sprint_time

-- Exploring the data more deeply to understand the columns
SELECT * FROM Driver_Standings where driverId=1
SELECT * FROM Driver_Standings where raceId=18

-- Number of races lewis hamilton has won
SELECT Count(raceid) from Results where driverId=1 and position=1 -- 103, which is correct!
-- Number of races mercedes as a constructor have won constructor id is 131
SELECT count(raceid) from Results where constructorId=131 and position=1 --125 wins

-- VISUALIZING THE DATA and CREATING THE VIEWS
-- DRIVER BASED VIEWS
-- Generalize and create a view that shows the number of races each driver has won!
DROP VIEW race_wins_by_driver
CREATE VIEW race_wins_by_driver as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Wins from (SELECT driverId, Count(raceId) as Wins from Results WHERE position = 1 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Wins desc offset 0 rows

-- Average finishing position of each driver
DROP VIEW avg_finish_position
CREATE VIEW avg_finish_position as SELECT CONCAT(d.forename,' ', d.surname) as driver_name, a.Avg_finishing_position FROM (SELECT driverId, avg(position) as Avg_finishing_position from Results GROUP BY driverId HAVING avg(position) is not NULL) a JOIN dimDrivers d on a.driverId = d.driverId  ORDER BY Avg_finishing_position asc offset 0 rows

-- Race starts for each driver
DROP VIEW race_starts_by_driver
CREATE VIEW race_starts_by_driver as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Starts from (SELECT driverId, Count(raceId) as Starts from Results GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.starts desc offset 0 rows

-- Fastest Laps for each driver
DROP VIEW fastest_laps_by_driver
CREATE VIEW fastest_laps_by_driver as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Fastest_Laps from (SELECT driverId, Count(raceId) as Fastest_Laps from Results WHERE rank = 1 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Fastest_Laps desc offset 0 rows

-- Most poles for each driver
DROP VIEW Poles_by_driver
CREATE VIEW Poles_by_driver as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Poles from (SELECT driverId, Count(raceId) as Poles from Qualifying WHERE position = 1 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Poles desc offset 0 rows

-- Most podiums for each driver
DROP VIEW Podiums_by_driver
CREATE VIEW Podiums_by_driver as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Podiums from (SELECT driverId, Count(raceId) as Podiums from Results WHERE position = 1 or position = 2 or position = 3 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Podiums desc offset 0 rows



-- CONSTRUCTOR VIEWS
-- Generalize and create a view that shows the number of races each constructor has won!
DROP VIEW race_wins_by_constructor
CREATE VIEW race_wins_by_constructor as SELECT name as constructor_name, r.Wins from (SELECT constructorId, Count(raceId) as Wins from Results WHERE position = 1 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Wins desc offset 0 rows

-- Average finishing position of each constructor
DROP VIEW avg_finish_position_c
CREATE VIEW avg_finish_position_c as SELECT name as constructor_name, a.Avg_finishing_position FROM (SELECT constructorId, avg(position) as Avg_finishing_position from Results GROUP BY constructorId HAVING avg(position) is not NULL) a JOIN dimConstructors d on a.constructorId = d.constructorId  ORDER BY Avg_finishing_position asc offset 0 rows

-- Race starts for each constructor
DROP VIEW race_starts_by_cons
CREATE VIEW race_starts_by_cons as SELECT name as constructor_name, r.Starts from (SELECT constructorId, Count(raceId) as Starts from Results GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.starts desc offset 0 rows

-- Fastest Laps for each cons
DROP VIEW fastest_laps_by_cons
CREATE VIEW fastest_laps_by_cons as SELECT name as constructor_name, r.Fastest_Laps from (SELECT constructorId, Count(raceId) as Fastest_Laps from Results WHERE rank = 1 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Fastest_Laps desc offset 0 rows

-- Most poles for each constructor
DROP VIEW Poles_by_constructor
CREATE VIEW Poles_by_constructor as SELECT name as constructor_name, r.Poles from (SELECT constructorId, Count(raceId) as Poles from Qualifying WHERE position = 1 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Poles desc offset 0 rows

-- Most podiums for each constructor
DROP VIEW Podiums_by_constructor
CREATE VIEW Podiums_by_constructor as SELECT name as constructor_name, r.Podiums from (SELECT constructorId, Count(raceId) as Podiums from Results WHERE position = 1 or position = 2 or position = 3 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Podiums desc offset 0 rows

-- Total points for each constructor
DROP VIEW Points_per_constructor
CREATE VIEW Points_per_constructor as SELECT name as constructor_name, r.Points from (SELECT constructorId, Sum(points) as Points from Results GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Points desc offset 0 rows


-- TRACK STATS
--Number of races held at each track
DROP VIEW races_held_at_track
CREATE VIEW races_held_at_track as SELECT name, count(raceId) as races FROM Race_Info GROUP BY name ORDER BY count(raceId) desc OFFSET 0 rows



-- CREATING TABLES FOR EAISER VISUALIZATIONS IN POWER BI. ONCE AGAIN DOING IT AT THE SOURCE
-- PODIUMS AND STUFF TABLE
DROP TABLE Podiums_Driver
CREATE TABLE Podiums_Driver (
	Driver_name varchar(100),
	Podiums int,
	P1 int,
	P2 int,
	P3 int,
	Most_Podiums_in_a_season int
)

CREATE VIEW Podiums_by_driver1 as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Podiums1 from (SELECT driverId, Count(raceId) as Podiums1 from Results WHERE position = 1 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Podiums1 desc offset 0 rows
CREATE VIEW Podiums_by_driver2 as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Podiums2 from (SELECT driverId, Count(raceId) as Podiums2 from Results WHERE position = 2 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Podiums2 desc offset 0 rows
CREATE VIEW Podiums_by_driver3 as SELECT Concat(d.forename,' ',d.surname) as driver_name, r.Podiums3 from (SELECT driverId, Count(raceId) as Podiums3 from Results WHERE position = 3 GROUP BY driverId) r JOIN dimDrivers d on r.driverId=d.driverId ORDER BY r.Podiums3 desc offset 0 rows
CREATE VIEW MostPodiums_Season as SELECT c.driver_name, max(c.podiums_in_season) as MostPodiums_in_a_season FROM (SELECT Concat(d.forename,' ',d.surname) as driver_name, p.Podiums_in_season from (SELECT r.driverId, Count(r.raceId) as Podiums_in_season, i.year FROM RESULTS r JOIN Race_Info i on r.raceId = i.raceId WHERE position = 1 or position = 2 or position = 3 GROUP BY r.driverId, i.year) p JOIN dimDrivers d on p.driverId=d.driverId ORDER BY p.Podiums_in_season desc offset 0 rows) c GROUP BY c.driver_name ORDER BY max(c.Podiums_in_season) desc offset 0 rows
INSERT INTO Podiums_driver (Driver_name, Podiums, P1, P2, P3, Most_Podiums_in_a_season)
	SELECT p.*, p1.Podiums1 as P1 , p2.Podiums2 as P2, p3.Podiums3 as P3, p4.MostPodiums_in_a_season as MostPodiums_in_a_Season FROM Podiums_by_driver p
		JOIN Podiums_by_driver1 p1 on p.driver_name = p1.driver_name
		JOIN Podiums_by_driver2 p2 on p.driver_name = p2.driver_name
		JOIN Podiums_by_driver3 p3 on p.driver_name = p3.driver_name
		JOIN MostPodiums_Season p4 on p.driver_name = p4.driver_name
DROP VIEW Podiums_by_driver1
DROP VIEW Podiums_by_driver2
DROP VIEW Podiums_by_driver3
DROP VIEW MostPodiums_Season
SELECT * FROM Podiums_Driver -- Completed the table, makes the visualization much easier. Dropped the unneeded views to use up less space

--Do the same for constructors
DROP TABLE Podiums_Constructor
CREATE TABLE Podiums_Constructor (
	Constructor_Name varchar(100),
	Podiums int,
	P1 int,
	P2 int,
	P3 int,
	Most_Podiums_in_a_season int
)

CREATE VIEW Podiums_by_cons1 as SELECT name as constructor_name, r.Podiums1 from (SELECT constructorId, Count(raceId) as Podiums1 from Results WHERE position = 1 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Podiums1 desc offset 0 rows
CREATE VIEW Podiums_by_cons2 as SELECT name as constructor_name, r.Podiums2 from (SELECT constructorId, Count(raceId) as Podiums2 from Results WHERE position = 2 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Podiums2 desc offset 0 rows
CREATE VIEW Podiums_by_cons3 as SELECT name as constructor_name, r.Podiums3 from (SELECT constructorId, Count(raceId) as Podiums3 from Results WHERE position = 3 GROUP BY constructorId) r JOIN dimConstructors d on r.constructorId=d.constructorId ORDER BY r.Podiums3 desc offset 0 rows
CREATE VIEW MostPodiums_Seasoncons as SELECT c.constructor_name, max(c.podiums_in_season) as MostPodiums_in_a_season FROM (SELECT name as constructor_name, p.Podiums_in_season from (SELECT r.constructorId, Count(r.raceId) as Podiums_in_season, i.year FROM RESULTS r JOIN Race_Info i on r.raceId = i.raceId WHERE position = 1 or position = 2 or position = 3 GROUP BY r.constructorId, i.year) p JOIN dimConstructors d on p.constructorId=d.constructorId ORDER BY p.Podiums_in_season desc offset 0 rows) c GROUP BY c.constructor_name ORDER BY max(c.Podiums_in_season) desc offset 0 rows
INSERT INTO Podiums_Constructor(Constructor_Name, Podiums, P1, P2, P3, Most_Podiums_in_a_season)
	SELECT p.*, p1.Podiums1 as P1 , p2.Podiums2 as P2, p3.Podiums3 as P3, p4.MostPodiums_in_a_season as MostPodiums_in_a_Season FROM Podiums_by_constructor p
		JOIN Podiums_by_cons1 p1 on p.constructor_name = p1.constructor_name
		JOIN Podiums_by_cons2 p2 on p.constructor_name = p2.constructor_name
		JOIN Podiums_by_cons3 p3 on p.constructor_name = p3.constructor_name
		JOIN MostPodiums_Seasoncons p4 on p.constructor_name = p4.constructor_name
DROP VIEW Podiums_by_cons1
DROP VIEW Podiums_by_cons2
DROP VIEW Podiums_by_cons3
DROP VIEW MostPodiums_Seasoncons
SELECT * FROM Podiums_Constructor -- Completed the table, makes the visualization much easier. Dropped the unneeded views to use up less space


-- WINS FROM A CERTAIN POSITION
SELECT grid, count(*) as wins_from FROM Results where driverId = 1 and position = 1 GROUP BY driverId, grid

-- CONSTRUCTORS EACH DRIVER HAS BEEN WITH
SELECT concat(d.forename, ' ', d.surname), c.number_of_cons FROM (SELECT driverId, count(DISTINCT constructorId) as number_of_cons from RESULTS GROUP BY driverId) c JOIN dimDrivers d ON c.driverId=d.driverId

-- RETIREMENTS
SELECT concat(d.forename, ' ', d.surname), c.number_of_rets FROM (SELECT driverId, count(statusId) as number_of_rets from RESULTS WHERE statusId not in (1,11,12,13,14,15,16,17,18,19,45,50,53,55,58,88,111,112,113,114,115,116,117,118,119,120,122,123,124,125,127,128,133,134) GROUP BY driverId) c JOIN dimDrivers d ON c.driverId=d.driverId


-- LAPS LED
CREATE VIEW Laps_Led_By_Driver as SELECT concat(d.forename, ' ', d.surname) as Driver, c.laps_led FROM (SELECT driverId, Count(lap) as laps_led from Lap_Times WHERE position = 1 GROUP BY driverId) c JOIN dimDrivers d ON c.driverId=d.driverId ORDER BY laps_led desc OFFSET 0 ROWS
