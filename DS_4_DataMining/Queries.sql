SELECT D.date, S.title as special_measure, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
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
GROUP BY (D.date)
ORDER BY D.date

--1.3.1: Rollup :
SELECT count(*) as cases, P.reporting_phu_city, D.year as year, D.quarter as quarter, D.month as month
FROM covid19_tracking_fact_table F, date_dimension D, PHU_location_dimension P
WHERE F.reported_date_key = D.surrogate_key AND
P.surrogate_key = F.PHU_location_key AND
F.unresolved = 1
GROUP BY P.reporting_phu_city, rollup(D.year, D.quarter, D.month)
ORDER BY D.year, D.quarter, D.month


XXXX
SELECT  P.reporting_phu_city, D.date, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F, phu_location_dimension P, date_dimension D, 
WHERE F.PHU_location_key = P.surrogate_key AND
	F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = L.surrogate_key AND
	F.special_measure_key = S.surrogate_key AND
	F.mobility_key = M.surrogate_key AND
	F.weather_key = W.surrogate_key AND
	F.patient_key = P.surrogate_key 

GROUP BY (D.date)
ORDER BY D.date
XXXX
-- 1.b.2
SELECT D.date as date, P.Reporting_PHU AS phu, 
	SUM(F.resolved) as resolved, 
	SUM(F.unresolved) as unresolved, 
	SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	date_dimension D, 
	special_measures_dimension S
WHERE F.PHU_location_key = P.surrogate_key AND
	F.special_measure_key = S.surrogate_key AND
	F.reported_date_key = D.surrogate_key AND
	S.title = 'Lockdown'
GROUP BY (phu,date)
ORDER BY date


-- 1.c.1
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


-- 1.c.2
SELECT L.reporting_phu_city,
	(case when M.parks_percent_change_from_baseline>41 then true else false end) as park,
	(case when M.transit_stations_percent_change_from_baseline>-54 then true else false end) as transit,
	SUM(F.unresolved) AS unresolved_cases
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




-- 1.d.1 rain and snow
SELECT W.totalsnowflag AS snow,
	W.totalrainflag AS rain,
	COUNT(*) AS cases
FROM covid19_tracking_fact_table F, 
	weather_dimension W
WHERE F.weather_key = W.surrogate_key AND
group by GROUPING SETS((rain),(snow))
ORDER BY snow,rain DESC

-- 1.d.2 date
SELECT MAX(D.year) AS year, D.month AS month, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key 
GROUP BY D.month
ORDER BY year, D.month ASC

-- 1.d.3 Measure
SELECT S.title AS title, SUM(F.resolved) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	special_measures_dimension S
WHERE F.PHU_location_key = P.surrogate_key AND
	F.special_measure_key = S.surrogate_key 
GROUP BY (S.title)
ORDER BY title



---------------------------------------------------------------

-- Part 2.2
SELECT  D.date AS day, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key 
GROUP BY (d.date)
order by cases DESC
LIMIT  10

-- Part2.2
SELECT distinct P.Reporting_PHU, 
	D.year,
	D.month,
	SUM(F.resolved+F.unresolved+F.fatal) AS total,
	RANK() OVER(
		PARTITION BY P.Reporting_PHU
		ORDER BY SUM(F.resolved+F.unresolved+F.fatal) DESC
	)
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = P.surrogate_key
GROUP BY ( P.Reporting_PHU, D.month, D.year)
ORDER BY P.Reporting_PHU, D.year, D.month ASC


--OR
-- over weeks and month and total
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

select datetime, AVG(totalsnowincm) OVER W
from weather_dimension
WINDOW W AS (
	ORDER BY DATE(datetime) 
	RANGE BETWEEN INTERVAL '1' MONTH PRECEDING AND INTERVAL '1' MONTH FOLLOWING
)

--Or
SELECT DISTINCT D.date, P.Reporting_PHU AS phu, SUM(F.resolved+F.unresolved+F.fatal) OVER W as cases
FROM covid19_tracking_fact_table F, phu_location_dimension P, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	F.PHU_location_key = P.surrogate_key AND
	P.reporting_phu_city = 'Ottawa'
WINDOW W AS (PARTITION BY DATE(D.date) 
ORDER BY DATE(D.date) 
RANGE BETWEEN INTERVAL '1' MONTH PRECEDING AND INTERVAL '1' MONTH FOLLOWING)
ORDER BY D.date




