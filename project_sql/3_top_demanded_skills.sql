/*
Question: What are the most in-demand skills for software engineering?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for a software engineer.
- Focus on job postings without seniority levels (e.g., Senior, Lead, Principal, Manager, Director, Sr)
- Why? Retrieves the top 10 skills with the highest demand in the job market, 
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
    jpf.job_title_short = 'Software Engineer' AND
    jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)'
GROUP BY
    skill
ORDER BY
    demand_count DESC
LIMIT 10;

/*
Here's the breakdown of the most demanded skills for software engineers in 2023:

- Python Dominance: Python leads the demand, indicating its critical role in software development, 
  particularly in data science, automation, and web development.
  
- Cloud and DevOps Skills: Skills like AWS, Azure, Kubernetes, Docker, and Git show a strong emphasis on cloud computing and 
  DevOps practices, highlighting the importance of infrastructure management and deployment automation in modern software engineering roles.
*\