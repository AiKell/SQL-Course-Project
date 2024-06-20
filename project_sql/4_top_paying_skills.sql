/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for software engineer positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for software engineers and 
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT
    skills_dim.skills AS skill,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim ON jpf.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    jpf.job_title_short = 'Software Engineer' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    skill
ORDER BY
    avg_salary DESC
LIMIT 25;

-- use chatGPT to analyze the results and paste some insights here