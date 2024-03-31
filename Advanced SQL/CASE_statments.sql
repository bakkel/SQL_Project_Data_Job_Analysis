-- Problem 1
SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 60000 AND 99999 THEN 'Standard Salary'
        WHEN salary_year_avg < 60000 THEN 'Low Salary'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;

-- Problem 2
SELECT
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM
    job_postings_fact;

-- Problem 3
SELECT
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_title ILIKE '%Lead%' OR job_title ILIKE '%Manager%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE  THEN 'Yes'
        WHEN job_work_from_home = FALSE  THEN 'No'
    END AS remote_option
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;

-- Problem 3 Alternative
SELECT
    job_postings.job_id,
    companies.name,
    job_postings.salary_year_avg,
    CASE
        WHEN job_postings.job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_postings.job_title ILIKE '%Lead%' OR job_postings.job_title ILIKE '%Manager%' THEN 'Lead/Manager'
        WHEN job_postings.job_title ILIKE '%Junior%' OR job_postings.job_title ILIKE '%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_postings.job_work_from_home = TRUE  THEN 'Yes'
        WHEN job_postings.job_work_from_home = FALSE  THEN 'No'
    END AS remote_option
FROM job_postings_fact AS job_postings
LEFT JOIN company_dim AS companies 
	ON job_postings.company_id = companies.company_id
WHERE
    job_postings.salary_year_avg IS NOT NULL
ORDER BY
    job_postings.job_id