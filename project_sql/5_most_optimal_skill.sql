
WITH skills_demand AS (
SELECT
skills_dim.skill_id,
skills_dim.skills,
COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
Job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
GROUP BY
skills_dim.skill_id
), average_salary AS (
SELECT
skills_job_dim.skill_id,
ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
Job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
GROUP BY
skills_job_dim.skill_id
)

SELECT
skills_demand.skill_id,
skills_demand.skills,
demand_count,
avg_salary 

FROM
skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
demand_count DESC,
avg_salary DESC
LIMIT 25;

/* This dataset gives a clear view of the relationship between **demand and salary** for data-related skills, and a few strong patterns emerge.

First, **SQL dominates demand (3,083 postings)**, but its average salary ($96K) sits slightly below some more technical skills. This shows that SQL is foundational — almost mandatory — but not necessarily a salary differentiator on its own. The same pattern appears with **Excel (2,143 postings, $86K)**: extremely common, but associated with lower average pay compared to more technical tools.

In contrast, **Python ($101K)** commands a higher average salary despite lower demand than SQL and Excel. This suggests programming capability increases earning potential. The same trend appears with **cloud and big data tools** like **AWS ($106K), Azure ($105K), Snowflake ($111K), and Spark ($113K)** — these have lower demand but higher salaries, indicating they are more specialized and tied to advanced data engineering or analytics roles.

Visualization tools such as **Tableau ($97K), Power BI ($92K), and Looker ($103K)** fall in the mid-to-high salary range, showing that data storytelling is valuable, but pairing it with technical infrastructure skills likely drives compensation higher.

Another notable pattern is that **office productivity tools (Word, Outlook, Sheets)** show both lower demand and lower salaries, reinforcing that they are complementary skills rather than core technical differentiators.

Overall, the market appears layered:

* **High demand + moderate salary** → SQL, Excel (core fundamentals)
* **Moderate demand + higher salary** → Python, Oracle, Looker (technical edge)
* **Lower demand + highest salary** → Cloud & big data tools (AWS, Azure, Snowflake, Spark)

The strongest earning potential seems to come from combining foundational analytics skills (SQL) with programming (Python) and cloud/data engineering technologies.

*/
