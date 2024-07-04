/*
Question: What are the top-paying software engineer jobs?
- Identify the top 10 highest-paying software engineer roles
- Focuses on job postings with specified salaries (remove nulls)
- Include company names of top 10 roles
- Omit seniority levels (e.g., Senior, Lead, Principal, Manager, Director, Sr)
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
    jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)' AND
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    avg_yearly_salary DESC
LIMIT 10;

/*
Here's the breakdown of the top software engineering jobs in 2023:

- Global Demand: There is a significant global demand for professionals in software engineering, as evidenced 
  by positions located in Russia, Australia, Spain, Switzerland, and the United States. Having 5 different 
  countries represented in the 10 highest paying jobs suggests that international jobs can be very lucrative. 

- Diverse Roles: The job postings also illustrate a diversity of specialized roles within the software engineering field. 
  Examples include "Staff Software Engineer - MLOps", focusing on machine learning operations, and "Computer Vision Engineer", 
  emphasizing expertise in computer vision technologies. This diversity reflects the varied and specialized nature of opportunities 
  available in the global job market.
*/