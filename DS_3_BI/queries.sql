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


-- a.2: ？？？
SELECT D.date AS day, COUNT(*) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11 AND
	D.day_of_month <= 7
GROUP BY D.date
ORDER BY D.date ASC


-- b.1
SELECT P.Reporting_PHU AS day, SUM(*) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F, phu_location_dimension P
WHERE F.PHU_location_key = P.surrogate_key 
GROUP BY (P.Reporting_PHU)


-- b.2
SELECT P.Reporting_PHU AS day, SUM(*) as resolved, SUM(F.unresolved) as unresolved, SUM(F.fatal) as fatal
FROM covid19_tracking_fact_table F,
	phu_location_dimension P,
	special_measures_dimension S
WHERE F.PHU_location_key = P.surrogate_key AND
	F.special_measure_key = S.surrogate_key AND
	S.title = 'Lockdown'
GROUP BY (P.Reporting_PHU)














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




