/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for software engineer roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

--CTE based on query 3
WITH skills_demand AS(
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skill,
        COUNT(jpf.job_id) AS demand_count
    FROM 
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim ON jpf.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        jpf.job_title_short = 'Software Engineer' AND
        jpf.salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
),

--CTE based on query 4
average_salary AS (
    SELECT
        skills_dim.skill_id,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim ON jpf.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        jpf.job_title_short = 'Software Engineer' AND
        jpf.salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skill,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary.avg_salary DESC,
    skills_demand.demand_count DESC
LIMIT 25;



--rewritten more concisely
SELECT
    skills_dim.skill_id,
    skills_dim.skills AS skill,
    COUNT(jpf.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim ON jpf.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    jpf.job_title_short = 'Software Engineer' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

-- use chatGPT to analyze the results and paste some insights here