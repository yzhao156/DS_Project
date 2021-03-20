select * from covid19_tracking_fact_table
-- ？？？a.2 1.3 几个query

-- a.1: Each day's case in 2020.11    TODO->count to sum
SELECT D.day_of_month AS day, COUNT(F.id) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11
GROUP BY D.day_of_month
ORDER BY D.day_of_month ASC


-- a.2: ？？？
SELECT D.day_of_month AS day, COUNT(F.id) AS cases
FROM covid19_tracking_fact_table F, date_dimension D
WHERE F.reported_date_key = D.surrogate_key AND
	D.year = 2020 AND
	D.Month = 11
GROUP BY D.day_of_month
ORDER BY D.day_of_month ASC


-- b.
SELECT P.Reporting_PHU, COUNT(Unresolved) AS total_cases 
FROM covid19_tracking_fact_table F , phu_location_dimension P
WHERE F.PHU_location_key = P.surrogate_key 
GROUP BY P.Reporting_PHU







SELECT COUNT(Unresolved) 
FROM covid19_tracking_fact_table F , phu_location_dimension P
WHERE F.PHU_location_key = P.surrogate_key AND
	P.Reporting_PHU_City = 'Toronto'
GROUP BY Unresolved








