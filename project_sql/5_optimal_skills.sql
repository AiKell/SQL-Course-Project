/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for software engineer roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
  offering strategic insights for career development in software engineering
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
        jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)' AND
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
        jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)' AND
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
    jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

/*
Here's a breakdown of the most optimal skills for software engineers in 2023: 

- High Salary Skills with Moderate Demand: TypeScript, with an average salary of $142,472 and a demand count 
  of 15, and Golang, with an average salary of $141,013 and a demand count of 12, offer some of the highest salaries 
  in the industry. Despite their moderate demand, these skills can significantly boost earning potential for software 
  engineers who specialize in them.

- Balanced Demand and Competitive Salary: C++ and Go show a good balance between demand and salary. C++ has a demand count 
  of 32 and an average salary of $134,176, while Go has a demand count of 42 and an average salary of $132,854. These skills 
  are highly sought after and offer competitive compensation.

- Emerging Technologies: Skills like Snowflake and Airflow are becoming increasingly important. Snowflake has a demand count 
  of 17 and an average salary of $126,339, whereas Airflow has a demand count of 13 and an average salary of $122,265. 
  These tools are gaining traction in data engineering and analytics.

- Popular Programming Languages: Python and JavaScript continue to be in high demand. Python, with a demand count of 131 and 
  an average salary of $113,243, and JavaScript, with a demand count of 44 and an average salary of $109,900, remain essential 
  for software development, offering numerous job opportunities.

- Specialized Skills: Technologies like TensorFlow (demand count 25, average salary $116,875) and Jenkins (demand count 11, average salary $115,450) 
  highlight the importance of specialized skills in machine learning and continuous integration/continuous deployment (CI/CD) for modern software 
  engineering roles. 
*/