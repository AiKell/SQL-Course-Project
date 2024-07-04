-- Query to get the percentage of job postings with yearly salary, hourly salary, and no salary information
SELECT 
    ROUND((COUNT(CASE WHEN salary_year_avg IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)), 3) AS percentage_with_yearly_salary,
    ROUND((COUNT(CASE WHEN salary_hour_avg IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)), 3) AS percentage_with_hourly_salary,
    ROUND((COUNT(CASE WHEN salary_year_avg IS NULL AND salary_hour_avg IS NULL THEN 1 END) * 100.0 / COUNT(*)), 3) AS percentage_with_no_information,
    COUNT(*) AS total_job_postings
FROM 
    job_postings_fact

UNION

-- Same query as above but filtering for software engineer and jobs at the non-senior level
SELECT 
    ROUND((COUNT(CASE WHEN salary_year_avg IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)), 3) AS percentage_with_yearly_salary,
    ROUND((COUNT(CASE WHEN salary_hour_avg IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)), 3) AS percentage_with_hourly_salary,
    ROUND((COUNT(CASE WHEN salary_year_avg IS NULL AND salary_hour_avg IS NULL THEN 1 END) * 100.0 / COUNT(*)), 3) AS percentage_with_no_information,
    COUNT(*) AS total_job_postings
FROM
    job_postings_fact
WHERE
    job_title_short = 'Software Engineer' AND
    job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)';