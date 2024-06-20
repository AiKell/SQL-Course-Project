/*
Question: What are the top-paying software engineer jobs?
- Identify the top 10 highest-paying software engineer roles that are available remotely
- Focuses on job postings with specified salaries (remove nulls)
- BONUS: Include company names of top 10 roles
- Why? Highlight the top-paying opportunities for software engineers, offering insights into employment options and location flexibility.
*/

SELECT
    jpf.job_id,
    jpf.job_title,
    jpf.job_location,
    jpf.job_posted_date::DATE,
    company_dim.name AS company,
    jpf.salary_year_avg AS avg_yearly_salary
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim ON jpf.company_id = company_dim.company_id
WHERE
    jpf.job_title_short = 'Software Engineer' AND
    jpf.job_work_from_home = TRUE AND
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    avg_yearly_salary DESC
LIMIT 10;