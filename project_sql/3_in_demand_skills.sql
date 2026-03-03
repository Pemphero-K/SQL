SELECT
skills,
COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
Job_title_short = 'Data Analyst'
GROUP BY
skills
ORDER BY
demand_count DESC
LIMIT 5

/*The data shows a clear pattern in what employers prioritize. SQL stands out by a wide margin, reinforcing that strong database querying skills are fundamental for data analyst roles. 
Excel and Python follow closely, indicating that companies value both traditional analytical tools and modern programming capabilities. Visualization platforms such as Tableau and Power BI also rank highly, highlighting the importance of communicating insights effectively through dashboards and reports.
 Beyond these core skills, demand declines more noticeably, suggesting that tools like R, SAS, Looker, and Azure are valuable but more specialized. Overall, the market favors well-rounded analysts who can extract, analyze, and present data efficiently across multiple platforms.*/


