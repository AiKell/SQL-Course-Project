/*
Question: What are the most in-demand skills for software engineering?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a software engineer.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/

SELECT
    skills_dim.skills AS skill,
    COUNT(jpf.job_id) AS demand_count
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim ON jpf.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    jpf.job_title_short = 'Software Engineer'
GROUP BY
    skill
ORDER BY
    demand_count DESC
LIMIT 5;