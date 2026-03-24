# Data Analyst Skills & Salary Analysis (SQL)

## Overview

This project uses SQL to analyse salary trends and skill demand across 
data analyst job postings. The analysis moves through four structured 
queries, each building on the last, to answer a core question: which 
skills actually drive compensation in the data analytics market, and 
where does the gap between demand and pay exist?

The dataset covers real job postings and includes salary figures, required 
skills, and company information. All queries were written in PostgreSQL and 
developed in VS Code.


---

## Background

The data analytics job market includes a wide spectrum of roles, from 
traditional reporting analysts to positions that overlap heavily with data 
engineering and cloud infrastructure. Foundational tools like SQL and Excel 
remain universally required, but there is a growing presence of 
programming, cloud, and big data technologies in job postings.

This project was built around four questions:

1. What are the highest-paying data analyst roles in the UK?
2. Which skills appear most frequently in those top-paying roles?
3. Which skills are associated with the highest average salaries across 
   the market?
4. Where does the gap between skill demand and compensation exist?

---

## Tools Used

| Tool | Purpose |
|---|---|
| PostgreSQL | Database system and query execution |
| VS Code | Development environment |
| Git | Version control |

**SQL concepts applied:**

- `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`
- Aggregate functions: `AVG()`, `COUNT()`, `ROUND()`
- `LEFT JOIN`, `INNER JOIN`
- Subqueries and CTEs (`WITH`)
- Null filtering and result limiting

---

## Analysis

### Query 1: Top-Paying Data Analyst Roles (UK)

The first query identifies the ten highest-paying data analyst roles 
based in the United Kingdom, filtering out postings with no salary 
listed.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'United Kingdom'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

This established a salary benchmark for the analysis and confirmed 
that significant variation exists across roles even within the same 
job title.

---

### Query 2: Skills Required for Top-Paying Roles

Using the results of Query 1 as a CTE, this query joins skill data 
to identify which specific skills appear across the ten 
highest-compensated roles.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'United Kingdom'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim 
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

**Findings:** Python and Excel appear most frequently across top-paying 
roles, closely followed by SQL. Visualization tools such as Tableau and 
Power BI are also well represented. Notably, tools like Jupyter, Git, 
and Shell appear in several postings, suggesting that many high-paying 
analyst roles extend into automation and data pipeline work. The pattern 
points toward hybrid profiles being the most rewarded: analysts who can 
code, automate, and communicate findings at a strategic level.

---

### Query 3: Most In-Demand Skills Across All Analyst Roles

This query shifts focus from salary to volume, identifying the five 
most frequently requested skills across all data analyst job postings 
in the dataset.
```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

**Findings:** SQL leads by a wide margin, confirming its status as 
a baseline requirement rather than a differentiating skill. Excel and 
Python follow, with Tableau and Power BI rounding out the top five. 
The results reinforce that the market expects analysts to be comfortable 
across both traditional tools and modern programming environments.

---

### Query 4: Demand vs. Salary Across Skills

The final query combines demand count and average salary into a single 
view using two CTEs joined on skill ID. This surfaces the clearest 
picture of where the demand-to-compensation gap exists.
```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_job_dim.skill_id
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary 
    ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;
```

**Findings:** The results reveal three distinct tiers in the market:

| Tier | Skills | Pattern |
|---|---|---|
| High demand, moderate salary | SQL ($96K), Excel ($86K) | Core requirements, near-universal but not differentiating |
| Moderate demand, higher salary | Python ($101K), Looker ($103K), Oracle | Technical edge that increases earning potential |
| Lower demand, highest salary | Snowflake ($111K), Spark ($113K), AWS ($106K), Azure ($105K) | Specialized, engineering-adjacent tools tied to the strongest compensation |

Office productivity tools such as Word, Outlook, and Sheets show both 
lower demand and lower average salaries, confirming they function as 
complementary skills rather than core technical qualifications.

---

## Key Findings

- SQL is the most in-demand skill by a significant margin but does not 
  independently drive the highest salaries
- High demand and high pay do not move together consistently across 
  the market
- Python adds meaningful salary uplift relative to SQL and Excel alone
- Cloud and big data tools (AWS, Azure, Snowflake, Spark) are 
  associated with the strongest compensation despite lower posting 
  frequency
- The boundary between data analyst and data engineer continues to 
  blur, with many top-paying analyst roles requiring scripting, 
  pipeline awareness, and version control

---

## Potential Extensions

- Filter and rerun the analysis specifically for the UK market to 
  compare whether the demand and salary patterns hold regionally
- Add a time dimension to track how skill demand and compensation 
  have shifted across quarters
- Rebuild the aggregation layer in Python (Pandas) and visualise 
  the demand vs. salary relationship as a scatter plot
- Cross-reference findings against live job postings via API to 
  validate whether the patterns from this dataset still hold

---

## Related Projects

- [Data Science Salary Dashboard (Excel)](link-to-repo)

---

## Author

**Pemphero Kenani**  
Finance & Accounting Student | Keele University  
[LinkedIn](https://www.linkedin.com/in/pemphero-kenani) |
[GitHub](https://github.com/Pemphero-K)