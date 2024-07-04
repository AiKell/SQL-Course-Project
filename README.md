# Introduction
💻 Navigate the software engineering job market! This project delves into 💰 top-paying software engineering roles, 🔧 in-demand skills, and 📈 where high demand meets high salary in software engineering.

🔍 Check out the SQL queries here: [project_sql folder](/project_sql/)

# Background
After continuously job-searching and applying without success, I realized the importance of acquiring the data analytics skills frequently listed in job postings. Through this process, not only did I learn the necessary skills, but I also gained valuable insights into which skills are most beneficial to learn next.

The data and project information come from [Luke Barousse's SQL Course](https://lukebarousse.com/sql). This data consists of job postings from 2023 and contains insights on job titles, salaries, locations, and essential skills.

### Acknowledgement of bias
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
Each query for this project aimed at investigating specific aspects of the software engineering job market. In particular, I focused on non-senior level positions, which I'm currently interested in. Here’s how I approached each question:

## 1. Top Paying Software Engineer Jobs
To identify the highest-paying roles, I filtered software engineering positions by average yearly salary and location. This query highlights the high-paying opportunities in the field.

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
Here's the breakdown of the top 10 paying software engineering jobs:

- **Global Demand:** There is a significant global demand for professionals in software engineering, as evidenced by positions located in Russia, Australia, Spain, Switzerland, and the United States. Having 5 different countries represented in the 10 highest paying jobs suggests that international jobs can be very lucrative. 
- **Diverse Roles:** The job postings also illustrate a diversity of specialized roles within the software engineering field. Examples include "Staff Software Engineer - MLOps", focusing on machine learning operations, and "Computer Vision Engineer", emphasizing expertise in computer vision technologies. This diversity reflects the varied and specialized nature of opportunities available in the global job market.

![Top paying roles](/assets/1_top_paying_jobs_histogram.png)
*Bar graph visualizing the top 10 software engineering positions based on yearly salary; generated using Python*

## 2. Skills for Top Paying Jobs
To understand what skills are required for top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

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

Here's an overview of the most demanded skills for software engineers, based on the 10 highest-paying job postings:

- **Python** and **Go** are leading with a high count of 5.

- **C++** closely follows with a count of 4 and **AWS** is right behind with a count of 3.

- Other skills show lower levels of demand with only 1 or 2 listings in the top 10 requiring them. Among these are programming languages like **C#** and **Ruby**, as well as machine learning frameworks like **TensorFlow** and **PyTorch**.

![Top paying job skills](/assets/2_skill_frequency_histogram.png)
*Bar graph visualizing the frequency of required skills among the top 10 highest paying software engineering postings; generated using Python*

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

Here's the breakdown of the overall most demanded skills for software engineers:

- **Python Dominance:** Python leads the demand, indicating its critical role in software development, particularly in data science, automation, and web development.

- **SQL Proficiency:** SQL comes second in demand which underscores its importance in software engineering positions. 

- **Cloud and DevOps Skills:** Skills like AWS, Azure, Kubernetes, Docker, and Git show a strong emphasis on cloud computing and DevOps practices, highlighting the importance of infrastructure management and deployment automation in modern software engineering roles.

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

*Table of the demand for the top 5 skills in software engineering job postings*

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

*Table of the top-paying skills for software engineers based on average salary data; shortened to the top 10 for brevity*


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

Here's a summary of the most essential skills for software engineers to learn:

- **High Salary Skills with Moderate Demand**: TypeScript, with an average salary of $142,472 and a demand count of 15, and Golang, with an average salary of $141,013 and a demand count of 12, offer some of the highest salaries in the industry. Despite their moderate demand, these skills can significantly boost the earning potential of software engineers who specialize in them.

- **Balanced Demand and Competitive Salary**: C++ and Go show a good balance between demand and salary. C++ has a demand count of 32 and an average salary of $134,176, while Go has a demand count of 42 and an average salary of $132,854. These skills are highly sought after and offer competitive compensation.

- **Emerging Technologies**: Skills like Snowflake and Airflow are becoming increasingly important. Snowflake has a demand count of 17 and an average salary of $126,339, whereas Airflow has a demand count of 13 and an average salary of $122,265. These tools are gaining traction in data engineering and analytics.

- **Popular Programming Languages**: Python and JavaScript continue to be in high demand. Python, with a demand count of 131 and an average salary of $113,243, and JavaScript, with a demand count of 44 and an average salary of $109,900, remain essential for software development, offering numerous job opportunities.

- **Specialized Skills**: Technologies like TensorFlow (demand count 25, average salary $116,875) and Jenkins (demand count 11, average salary $115,450) highlight the importance of specialized skills in machine learning and continuous integration/continuous deployment (CI/CD) for modern software engineering roles. 

| Skill      | Demand count | Average salary |
|------------|--------------|----------------|
| typescript | 15           | $142,472       |
| golang     | 12           | $141,013       |
| c++        | 32           | $134,176       |
| go         | 42           | $132,854       |
| snowflake  | 17           | $126,339       |
| airflow    | 13           | $122,265       |
| flow       | 14           | $119,684       |
| tensorflow | 25           | $116,875       |
| jenkins    | 11           | $115,450       |
| jira       | 14           | $114,774       |
| react      | 26           | $114,325       |
| python     | 131          | $113,243       |
| spark      | 35           | $112,207       |
| terraform  | 12           | $111,575       |
| linux      | 25           | $111,326       |
| javascript | 44           | $109,900       |
| c#         | 18           | $109,042       |
| scala      | 18           | $108,593       |
| kafka      | 25           | $108,576       |
| aws        | 75           | $108,166       |
| angular    | 15           | $105,599       |
| excel      | 36           | $104,211       |
| java       | 68           | $103,280       |
| azure      | 47           | $103,008       |
| pytorch    | 19           | $101,434       |

*Table of the most optimal skills for software engineers sorted by salary*

**Note:** The difference in demand count from `section 4` arises because a significant portion of job postings in the dataset do not include salary information. This observation is reflected in the table below, which outlines the distribution of available salary information across all job postings.

|                                         | Has Yearly Salary Info (%) | Has Hourly Salary Info (%) | Has no Salary Info (%) | Number of Jobs |
|-----------------------------------------|----------------------------|----------------------------|------------------------|----------------|
| All jobs                                | 2.797                      | 1.354                      | 95.849                 | 787,686        |
| Software Engineering (non-senior level) | 1.013                      | 0.256                      | 98.731                 | 30,493         |

*Table showing the distribution of salary information in job postings*

# What I learned
Throughout this experience, I have enhanced my SQL toolkit with advanced skills:

- **🧩 Complex Query Crafting:** Mastering advanced SQL techniques, adeptly merging tables, and utilizing WITH clauses for effective temporary table management.
- **📊 Data Aggregation:** Proficiency in GROUP BY operations, utilizing aggregate functions like COUNT() and AVG() to summarize data effectively.
- **💡 Analytical Expertise:** Strengthening my problem-solving abilities, transforming queries into actionable insights through strategic SQL formulation.


# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Software Engineering Jobs**: The highest-paying jobs for software engineers at non-senior level positions are located all over the globe.

2. **Skills for Top-Paying Jobs**: Python and Go emerge as leading skills in demand for high-paying software engineering roles, showcasing the importance of versatile programming languages in securing top-tier positions.

3. **Most In-Demand Skills**: Python and SQL dominate as the most in-demand skills for software engineers, underscoring their foundational roles across various software engineering positions.

4. **Skills with Higher Salaries**: Skills like Ruby on Rails and Unity command exceptionally high average salaries, highlighting the financial rewards of specializing in specific frameworks and technologies.

5. **Optimal Skills for Job Market Value**: TypeScript and Golang emerge as optimal skills to learn, balancing high average salaries with moderate demand, offering strategic opportunities for career growth in software engineering.

### Closing Thoughts

Throughout this project, I have not only enhanced my technical skills in SQL and data analysis but also gained deeper insights into the nuanced factors shaping career trajectories in software engineering. Mastering advanced SQL techniques, understanding the importance of data-driven decision-making, and navigating complex job market dynamics have been invaluable lessons that will guide my career development going forward.
