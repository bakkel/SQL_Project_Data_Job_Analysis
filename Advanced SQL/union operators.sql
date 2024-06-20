-- Problem 1
(
    SELECT
        job_id,
        job_title,
        'With salary info' AS salary_info
    FROM
        job_postings_fact
    WHERE
        salary_hour_avg IS NOT NULL
        AND salary_hour_avg IS NOT NULL
)
UNION ALL
(
    SELECT
        job_id,
        job_title,
        'Without salary info' AS salary_info
    FROM
        job_postings_fact
    WHERE
        salary_hour_avg IS NULL
        AND salary_hour_avg IS NULL
)
ORDER BY
    salary_info DESC,
    job_id;

-- Problem 2