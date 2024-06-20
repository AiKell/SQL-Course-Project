/*
Question: What skills are required for the top-paying software engineer jobs?
- Use the top 10 highest-paying software engineer jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/
WITH top_paying_jobs AS(
    SELECT
        jpf.job_id,
        jpf.job_title,
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
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills AS required_skill
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    avg_yearly_salary DESC;

-- use chatGPT to analyze the results and paste some insights here