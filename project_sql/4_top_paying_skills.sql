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
    jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    skill
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
These top paying skills for software engineers reveal some interesting trends:

1.  Diverse Database Skills: Neo4j, DynamoDB, Couchbase, graphQL, and MongoDB all show high salaries, 
    reflecting the importance of handling large-scale data and specialized data models.
    
2.  Emerging Languages: Languages like Go, Julia, and Clojure are in demand, likely due to their 
    efficiency, scalability, and specialized use cases in modern software development.

3.  Web Development: ASP.NET Core, Ruby on Rails, Express, and Next.js highlight the 
    ongoing demand for web development frameworks, especially those supporting modern web applications and APIs.

Overall, these trends suggest that specialization in either cutting-edge technologies (like specific databases and languages) 
can significantly impact software engineers' earning potential.
*/