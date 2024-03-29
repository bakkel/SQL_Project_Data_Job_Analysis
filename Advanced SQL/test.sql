SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'UTC +1'
FROM job_postings_fact
LIMIT 5;