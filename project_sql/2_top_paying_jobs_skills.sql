/*question: What skills are required for top-paying data analyst jobs?
-use the top 10 highest-paying data analyst jobs from first query
-add the specific skills required for these roles
- why? it provides a detailed look at which high-paying jobs demand certain skills, helping job seekers figure out which skills they should develop to align with top salaries
*/

WITH top_paying_jobs AS (

SELECT
job_id,
job_title,
salary_year_avg,
name AS company_name
FROM
job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
job_title_short = 'Data Analyst' AND
job_location = 'United Kingdom' AND salary_year_avg IS NOT null
ORDER BY
salary_year_avg DESC
LIMIT 10
)

SELECT
top_paying_jobs.*,
skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
salary_year_avg DESC

/* Analysis of the 2023 top-paying data analyst postings shows that the highest salaries consistently reward strong technical foundations combined with analytical storytelling skills.
 **Python and Excel** appear most frequently, closely followed by **SQL**, confirming that advanced data manipulation and querying remain core requirements.
  At the same time, tools like **Tableau** and **Power BI** highlight the importance of visualization and business communication. 
  The presence of scripting and workflow tools such as **Jupyter, Git, and Shell** suggests that many high-paying “analyst” roles extend beyond reporting into automation, data pipeline support, and engineering-adjacent responsibilities. 
  Overall, top salaries favor hybrid profiles—analysts who can code, automate, and translate complex data into strategic insights. */



