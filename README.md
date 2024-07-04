# Introduction
💻 Navigate the software engineering job market! This project delves into 💰 top-paying software engineering roles, 🔧 in-demand skills, and 📈 where high demand meets high salary in software engineering.

🔍 Check out the SQL queries here: [project_sql folder](/project_sql/)

# Background
After continuously job-searching and applying without success, I realized the importance of acquiring the data analytics skills frequently listed in job postings. Through this process, not only did I learn the necessary skills, but I also gained valuable insights into which skills are most beneficial to learn next.

The data and project information comes from [Luke Barousse's SQL Course](https://lukebarousse.com/sql). This data consists of job postings from 2023 and contains insights on job titles, salaries, locations, and essential skills.

### Acknowledgement of Bias
The dataset used in this analysis primarily consists of job postings that focus on data science roles. While this may introduce some bias, as the data might not fully capture the entire software engineering job market, the insights gained are still highly relevant. This is because many of the skills and trends identified in data science roles overlap with those in software engineering, reflecting broader industry demands and highlighting key areas for skill development.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying software engineering jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for software engineers?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used
For my deep dive into the software engineering job market, I took advantage of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My day to day editor for writing and executing code.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
- **Python, Pandas, & Seaborn:** Used to help visualize data returned from queries. 

# The Analysis
Each query for this project aimed at investigating specific aspects of the software engineering job market. In particular, I focused on non-senior-level positions, as that is what I'm currently interested in. Here’s how I approached each question:

## 1. Top Paying Software Engineer Jobs
To identify the highest-paying roles, I filtered software engineering positions by average yearly salary and location. This query highlights the high paying opportunities in the field.

```sql
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
```
Here's the breakdown of the top software engineering jobs in 2023:

- **Global Demand:** There is a significant global demand for professionals in software engineering, as evidenced by positions located in Russia, Australia, Spain, Switzerland, and the United States. Having 5 different countries represented in the 10 highest paying jobs suggests that international jobs can be very lucrative. 
- **Diverse Roles:** The job postings also illustrate a diversity of specialized roles within the software engineering field. Examples include "Staff Software Engineer - MLOps", focusing on machine learning operations, and "Computer Vision Engineer", emphasizing expertise in computer vision technologies. This diversity reflects the varied and specialized nature of opportunities available in the global job market.

![Top paying roles](/assets/1_top_paying_jobs_histogram.png)
*Bar graph visualizing the top 10 software engineering positions based on yearly salary; generated using python*

## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
        jpf.job_title !~* '(Senior|Lead|Principal|Manager|Director|Sr)' AND
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
```

Here's the breakdown of the most demanded skills for software engineers in 2023, based on the 10 highest palying job postings:

- **Python** and **Go** are leading with a high count of 5.
- **C++** closely follows with a count of 4 and **AWS** is right behind with a count of 3.
- Other skills show lower levels of demand with only 1 or 2 listings in the top 10 requiring them. Among these are programming languages like **C#** and **Ruby**, as well as machine learning frameworks like **TensorFlow** and **PyTorch**.

![Top paying job skills](/assets/2_skill_frequency_histogram.png)
*Bar graph visualizing the frequency of required skills among the top 10 highest paying software engineering postings; generated using python*

## 3. In-Demand Skills for Software Engineers

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
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
```
Here's the breakdown of the most demanded skills for software engineers in 2023:

- **Python Dominance**: Python leads the demand, indicating its critical role in software development, particularly in data science, automation, and web development.
  
- **Cloud and DevOps Skills**: Skills like AWS, Azure, Kubernetes, Docker, and Git show a strong emphasis on cloud computing and DevOps practices, highlighting the importance of infrastructure management and deployment automation in modern software engineering roles.

| Skill       | Demand Count |
|-------------|--------------|
| Python      | 10090        |
| SQL         | 8507         |
| AWS         | 6005         |
| Java        | 5954         |
| Azure       | 4462         |
| Kubernetes  | 3910         |
| Linux       | 3879         |
| Docker      | 3820         |
| JavaScript  | 3196         |
| Git         | 3048         |
*Table of the demand for the top 10 skills in software engineering job postings*

## 4. Skills Based on Salary
This query explores the average salaries associated with different skills, revealing which skills are the highest paying for software engineers.

```sql
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
```

These top-paying skills for software engineers reveal some interesting trends:

- **Diverse Database Skills:** Skills such as **Neo4j**, **DynamoDB**, **Couchbase**, **GraphQL**, and **MongoDB** command high salaries, underscoring the importance of managing large-scale data and specialized data models in software engineering.

- **Emerging Languages:** Languages like **Go**, **Julia**, and **Clojure** are in demand, likely due to their efficiency, scalability, and specialized applications in modern software development.

- **Web Development:** Frameworks such as **ASP.NET Core**, **Ruby on Rails**, **Express**, and **Next.js** highlight the continuous demand for web development tools, especially those supporting modern web applications and APIs.

These trends indicate that specialization in cutting-edge technologies, whether in databases, languages, or web development frameworks, can significantly impact software engineers' earning potential.


| Skill          | Average Salary |
|----------------|----------------|
| Ruby on Rails  | $217,500       |
| Unity          | $208,500       |
| Next.js        | $175,250       |
| Assembly       | $167,327       |
| Neo4j          | $155,000       |
| FastAPI        | $152,750       |
| Aurora         | $151,233       |
| Julia          | $142,500       |
| TypeScript     | $142,472       |
| DB2            | $142,430       |

*Table of the top-paying skills for software engineers based on average salary data. Shortened to the top 10 for brevity.*

## 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```
PUT TABLE OR GRAPH HERE

### Optimal Skills for Software Engineers in 2023

Here's a breakdown of the most optimal skills for software engineers in 2023:

1. **Cloud Dominance**: AWS stands out with high demand and salaries, emphasizing cloud expertise.

2. **Language Versatility**: Python and Go demonstrate strong market value across diverse applications.

3. **Specialized Technologies**: Kafka and Snowflake show high salaries due to their niche roles in data management.

4. **Frontend Leadership**: React and TypeScript lead in frontend development, commanding competitive salaries.

5. **Backend Stability**: Node.js maintains high salaries despite moderate demand, crucial for backend roles.


# What I leaned
Throughout this experience, I have enhanced my SQL toolkit with advanced skills:

- **🧩 Complex Query Crafting:** Mastering advanced SQL techniques, adeptly merging tables and utilizing WITH clauses for effective temporary table management.
- **📊 Data Aggregation:** Proficiency in GROUP BY operations, utilizing aggregate functions like COUNT() and AVG() to summarize data effectively.
- **💡 Analytical Expertise:** Strengthening my problem-solving abilities, transforming queries into actionable insights through strategic SQL formulation.


# Conclusions

### Insights
From the analysis, several general insights emerged:


### Closing Thoughts

Overall, I learned a great deal from this course 