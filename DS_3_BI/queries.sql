select * from covid19_tracking_fact_table
-- ？？？a.2 1.3 几个query

-- a.1: Each day's case in 2020.11    TODO->count to sum
SELECT D.date AS day, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11
GROUP BY D.date
ORDER BY D.date ASC

--OR

SELECT D.date AS day, d.month as month, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11
GROUP BY GROUPING SETS((D.month),(D.date))
ORDER BY D.month, D.date 



-- a.2: ？？？
SELECT D.date AS day, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11 AND
	D.day_of_month <= 7
GROUP BY D.date
ORDER BY D.date ASC

--OR

SELECT D.date AS day, D.week as week, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.month = 11 AND
	D.week =44
GROUP BY GROUPING SETS ((D.date),(D.week))
ORDER BY D.date ASC

-- b.1
SELECT P.Reporting_PHU AS phu, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F, phu_location_dimension P
WHERE F.PHU_location_key = P.surrogate_key 
GROUP BY (P.Reporting_PHU)


-- b.2
SELECT P.Reporting_PHU AS day, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	special_measures_dimension S
WHERE F.PHU_location_key = P.surrogate_key AND
	F.special_measure_key = S.surrogate_key AND
	S.title = 'Lockdown'
GROUP BY (P.Reporting_PHU)




-- c.1
SELECT D.month as month, L.reporting_phu_city as city, SUM(F.fatal) AS fatal_cases
FROM covid19_tracking_fact_table F, 
	date_dimension D, 
	phu_location_dimension L
WHERE F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = L.surrogate_key AND
	(D.month=11 OR D.month=12) AND
	D.year=2020 AND
	(L.reporting_phu_city = 'Oakville' OR L.reporting_phu_city = 'Ottawa') AND
	F.fatal = 1
GROUP BY (D.month, L.reporting_phu_city)
ORDER BY D.month

-- c.2


SELECT L.reporting_phu_city,
	(case when M.parks_percent_change_from_baseline>41 then true else false end) as park,
	(case when M.transit_stations_percent_change_from_baseline>-54 then true else false end) as transit,
	SUM(F.unresolved) AS unsolved_cases
FROM covid19_tracking_fact_table F, 
	mobility_dimension M, 
	phu_location_dimension L
WHERE F.mobility_key = M.surrogate_key AND
	F.PHU_location_key = L.surrogate_key AND
	(L.reporting_phu_city = 'Oakville' OR L.reporting_phu_city = 'Ottawa') 
group by (park, transit, L.reporting_phu_city)
ORDER BY L.reporting_phu_city

--AUXS
select avg(parks_percent_change_from_baseline) as park,
avg(transit_stations_percent_change_from_baseline) as transit 
from mobility_dimension
--41,-54

select (case when parks_percent_change_from_baseline>41 then true else false end) as park,
(case when transit_stations_percent_change_from_baseline>-54 then true else false end) as transit
from mobility_dimension
group by (park, transit)




-- d.1 weather

SELECT W.totalsnowflag AS snow,
	(case when M.parks_percent_change_from_baseline>41 then true else false end) as park,
	(case when M.transit_stations_percent_change_from_baseline>-54 then true else false end) as transit,
	COUNT(*) AS cases
FROM covid19_tracking_fact_table F, 
	mobility_dimension M, 
	weather_dimension W
WHERE F.mobility_key = M.surrogate_key AND
	F.weather_key = W.surrogate_key 
group by GROUPING SETS((park, transit, W.totalsnowflag),(snow))
ORDER BY snow DESC


-- d.2 date
SELECT MAX(D.year) AS year, D.month AS month, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key 
GROUP BY D.month
ORDER BY year, D.month ASC

-- d.3 

SELECT S.title AS title, CASE WHEN P.reporting_phu_city='Ottawa' THEN 'Ottawa' else 'Toronto' END AS city, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	special_measures_dimension S
WHERE F.PHU_location_key = P.surrogate_key AND
	F.special_measure_key = S.surrogate_key 
GROUP BY (S.title, city)
ORDER BY city, title

-- or

SELECT S.title AS title, P.reporting_phu_city AS city, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	special_measures_dimension S
WHERE F.PHU_location_key = P.surrogate_key AND
	F.special_measure_key = S.surrogate_key 
GROUP BY (S.title,P.reporting_phu_city)
ORDER BY title



---------------------------------------------------------------

-- Part2.1
SELECT  D.date AS day, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key 
GROUP BY (d.date)
LIMIT  10

-- Part2.2
SELECT DISTINCT P.Reporting_PHU, 
	D.date,
	SUM(F.resolved+F.unresolved+F.fatal) OVER (PARTITION BY P.Reporting_PHU,D.week) AS week,
	SUM(F.resolved+F.unresolved+F.fatal) OVER (PARTITION BY P.Reporting_PHU,D.month) AS month,
	SUM(F.resolved+F.unresolved+F.fatal) OVER (PARTITION BY P.Reporting_PHU) AS total
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = P.surrogate_key
ORDER BY week DESC


-- Part2.3


SELECT D.date, P.Reporting_PHU AS phu, SUM(F.resolved+F.unresolved+F.fatal) OVER W as cases
FROM covid19_tracking_fact_table F, phu_location_dimension P, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = P.surrogate_key AND
	P.reporting_phu_city = 'Ottawa'
WINDOW W AS (PARTITION BY DATE(D.date) 
ORDER BY DATE(D.date) 
RANGE BETWEEN INTERVAL '1' MONTH PRECEDING AND INTERVAL '1' MONTH FOLLOWING)

-- or

select datetime, AVG(totalsnowincm) OVER W
from weather_dimension
WINDOW W AS (
	ORDER BY DATE(datetime) 
	RANGE BETWEEN INTERVAL '1' MONTH PRECEDING AND INTERVAL '1' MONTH FOLLOWING)




SELECT D.date, D.day_of_month AS day, S.title as special_measure, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, 
	date_dimension D, 
	phu_location_dimension L,
	weather_dimension W,
	mobility_dimension M,
	special_measures_dimension S,
	patient_dimension P
WHERE F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = L.surrogate_key AND
	F.special_measure_key = S.surrogate_key AND
	F.mobility_key = M.surrogate_key AND
	F.weather_key = W.surrogate_key AND
	F.patient_key = P.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11
GROUP BY (D.day_of_month, S.title, D.date)
ORDER BY D.day_of_month ASC




