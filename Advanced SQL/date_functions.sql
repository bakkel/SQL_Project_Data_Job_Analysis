-- Problem 1
SELECT 
    job_schedule_type,
     AVG(salary_year_avg) AS year_avg,
     AVG(salary_hour_avg) AS hour_avg
FROM job_postings_fact
WHERE
    job_posted_date::DATE > '2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type;

-- Problem 2
SELECT
	EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS job_posted_count
FROM
	job_postings_fact
GROUP BY month
ORDER BY month;

-- 1e poging Problem 3
SELECT
    company_dim.name AS company_name,
    COUNT(job_id) AS job_postings_count
FROM 
    job_postings_fact
        INNER JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_postings_fact.job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
GROUP BY
    company_dim.name
HAVING
    COUNT(job_id) > 0
ORDER BY
    job_postings_count DESC;

-- 2e poging Problem 3
SELECT
    company_dim.name AS Company_name,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
    INNER JOIN 
    company_dim ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_health_insurance = TRUE
    AND
    EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
GROUP BY
    company_dim.name
HAVING
    COUNT(job_postings_fact.job_id) > 0
ORDER BY
    job_count DESC