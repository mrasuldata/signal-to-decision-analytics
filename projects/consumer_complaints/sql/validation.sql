-- Run after populate.sql for 01_consumer_complaints; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `complaint_id`)) AS distinct_source_keys FROM `consumer_complaints`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_complaint_id FROM `consumer_complaints` WHERE `complaint_id` IS NULL OR `complaint_id` = '';
SELECT MIN(`complaint_month`) AS first_period, MAX(`complaint_month`) AS last_period FROM `consumer_complaints`;
SELECT ROUND(100 * AVG(`timely_flag`), 2) AS full_cohort_timely_pct FROM `consumer_complaints`;
