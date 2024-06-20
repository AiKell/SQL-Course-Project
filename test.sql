WITH combined_job_postings AS( 
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
),

monthly_skill_demand AS (
  SELECT
    skills_dim.skills,  
    EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
    EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
    COUNT(combined_job_postings.job_id) AS postings_count 
  FROM
    combined_job_postings
	  INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
	  INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
  GROUP BY
    skills_dim.skills, year, month
)

SELECT
   skills,
   year,
   month,
   postings_count
FROM
    monthly_skill_demand
ORDER BY
    skills, year, month