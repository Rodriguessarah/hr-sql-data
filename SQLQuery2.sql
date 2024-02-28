SELECT *
FROM hr_data;

select termdate from hr_data;

UPDATE hr_data
SET termdate = FORMAT(CONVERT(DATETIME, LEFT(termdate, 19), 120), 'yyyy-MM-dd');


ALTER TABLE hr_data
ADD new_termdate DATE;

UPDATE hr_data
SET new_termdate = CASE
 WHEN termdate IS NOT NULL AND ISDATE(termdate) = 1 THEN CAST(termdate AS DATETIME) ELSE NULL
 END;


 SELECT new_termdate
FROM hr_data;

ALTER TABLE hr_data
ADD age nvarchar(50)

UPDATE hr_data
SET age = DATEDIFF(YEAR, birthdate, GETDATE());

SELECT
 MIN(age) AS youngest,
 MAX(age) AS OLDEST
FROM hr_data;

select age from hr_data
order by age;


SELECT age_group,
count(*) AS count
FROM
(SELECT 
 CASE
  WHEN age <= 22 AND age <= 30 THEN '21 to 30'
  WHEN age <= 31 AND age <= 40 THEN '31 to 40'
  WHEN age <= 41 AND age <= 50 THEN '41 to 50'
  ELSE '50+'
  END AS age_group
 FROM hr_data
 WHERE new_termdate IS NULL
 ) AS subquery
GROUP BY age_group
ORDER BY age_group;

SELECT age_group,
gender,
count(*) AS count
FROM
(SELECT 
 CASE
  WHEN age <= 22 AND age <= 30 THEN '21 to 30'
  WHEN age <= 31 AND age <= 40 THEN '31 to 40'
  WHEN age <= 41 AND age <= 50 THEN '41 to 50'
  ELSE '50+'
  END AS age_group,
  gender
 FROM hr_data
 WHERE new_termdate IS NULL
 ) AS subquery
GROUP BY age_group, gender
ORDER BY age_group, gender;

SELECT
 gender,
 COUNT(gender) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY gender
ORDER BY gender ASC;


SELECT 
department,
gender,
count(gender) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY department, gender
ORDER BY department, gender;

SELECT 
department, jobtitle,
gender,
count(gender) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY department, jobtitle, gender
ORDER BY department, jobtitle, gender ASC;

SELECT
race,
count(*) AS count
FROM
hr_data
WHERE new_termdate IS NULL 
GROUP BY race
ORDER BY count DESC;

SELECT 
AVG(DATEDIFF(year, hire_date, new_termdate)) AS tenure
FROM hr_data
WHERE new_termdate IS NOT NULL AND new_termdate <= GETDATE();

SELECT
 department,
 total_count,
 terminated_count,
 (round((CAST(terminated_count AS FLOAT)/total_count), 2)) * 100 AS turnover_rate
 FROM
	(SELECT 
	 department,
	 count(*) AS total_count,
	 SUM(CASE
		WHEN new_termdate IS NOT NULL AND new_termdate <= GETDATE() THEN 1 ELSE 0
		END
		) AS terminated_count
	FROM hr_data
	GROUP BY department
	) AS subquery
ORDER BY turnover_rate DESC;

SELECT 
    department,
    AVG(DATEDIFF(year, hire_date, new_termdate)) AS tenure
FROM 
    hr_data
WHERE 
    new_termdate IS NOT NULL 
    AND new_termdate <= GETDATE()
GROUP BY 
    department;

	SELECT
 hire_year,
 hires,
 terminations,
 hires - terminations AS net_change,
 (round(CAST(hires-terminations AS FLOAT)/hires, 2)) * 100 AS percent_hire_change
 FROM
	(SELECT 
	 YEAR(hire_date) AS hire_year,
	 count(*) AS hires,
	 SUM(CASE
			WHEN new_termdate is not null and new_termdate <= GETDATE() THEN 1 ELSE 0
			END
			) AS terminations
	FROM hr_data
	GROUP BY YEAR(hire_date)
	) AS subquery
ORDER BY percent_hire_change ASC;