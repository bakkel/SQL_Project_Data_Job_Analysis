-- Problem 1
WITH
    job_count AS (
        SELECT
            company_id,
            COUNT(DISTINCT (job_title)) AS unique_job_titles
        FROM
            job_postings_fact
        GROUP BY
            company_id
    )
SELECT
    company_dim.name AS company,
    job_count.unique_job_titles
FROM
    job_count
    LEFT JOIN company_dim on job_count.company_id = company_dim.company_id
ORDER BY
    job_count.unique_job_titles DESC
LIMIT
    15;

-- Problem 2
WITH
    avg_salaries_country AS (
        SELECT
            job_country,
            AVG(salary_year_avg) AS average_salary
        FROM
            job_postings_fact
        GROUP BY
            job_country
    )
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    company_dim.name AS company_name,
    job_postings_fact.salary_year_avg AS salary_rate,
    CASE
        WHEN job_postings_fact.salary_year_avg > avg_salaries_country.average_salary THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_category,
    EXTRACT(
        MONTH
        FROM
            job_postings_fact.job_posted_date
    ) AS date_month
FROM
    job_postings_fact
    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    INNER JOIN avg_salaries_country ON job_postings_fact.job_country = avg_salaries_country.job_country
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY
    date_month DESC;

/* Problem 3

Calculate the number of unique skills required by each company. Aim to quantify the unique skills required per company and identify which of these companies offer the highest average salary for positions necessitating at least one skill. For entities without skill-related job postings, list it as a zero skill requirement and a null salary. Use CTEs to separately assess the unique skill count and the maximum average salary offered by these companies.*/
WITH
    unique_company_skills AS (
        SELECT
            companies.company_id,
            COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills
        FROM
            company_dim AS companies
            LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
            LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
        GROUP BY
            companies.company_id
    ),
    max_salary_company AS (
        SELECT
            job_postings_fact.company_id,
            MAX(job_postings_fact.salary_year_avg) AS max_salary
        FROM
            job_postings_fact
        WHERE
            job_postings_fact.job_id IN (
                SELECT
                    job_id
                FROM
                    skills_job_dim
            )
        GROUP BY
            job_postings_fact.company_id
    )
SELECT
    company_dim.name,
    unique_company_skills.unique_skills AS unique_skills_required,
    max_salary_company.max_salary
FROM
    company_dim
    LEFT JOIN unique_company_skills ON company_dim.company_id = unique_company_skills.company_id
    LEFT JOIN max_salary_company ON company_dim.company_id = max_salary_company.company_id
ORDER BY
    company_dim.company_id;