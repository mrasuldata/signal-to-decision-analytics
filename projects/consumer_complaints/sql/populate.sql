-- Manual MySQL population for 01_consumer_complaints.
-- First run schema.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 01_consumer_complaints.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `consumer_complaints`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/01_consumer_complaints.csv'
INTO TABLE `consumer_complaints`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @complaint_id,
    @date_received,
    @date_sent,
    @complaint_month,
    @product,
    @issue,
    @company,
    @state,
    @submitted_via,
    @company_response_to_consumer,
    @days_to_send,
    @timely_flag,
    @disputed_flag,
    @company_volume,
    @company_timely_rate,
    @product_timely_rate,
    @response_risk_score,
    @review_band
)
SET
    `complaint_id` = NULLIF(@complaint_id, ''),
    `date_received` = NULLIF(@date_received, ''),
    `date_sent` = NULLIF(@date_sent, ''),
    `complaint_month` = NULLIF(@complaint_month, ''),
    `product` = NULLIF(@product, ''),
    `issue` = NULLIF(@issue, ''),
    `company` = NULLIF(@company, ''),
    `state` = NULLIF(@state, ''),
    `submitted_via` = NULLIF(@submitted_via, ''),
    `company_response_to_consumer` = NULLIF(@company_response_to_consumer, ''),
    `days_to_send` = NULLIF(@days_to_send, ''),
    `timely_flag` = NULLIF(@timely_flag, ''),
    `disputed_flag` = NULLIF(@disputed_flag, ''),
    `company_volume` = NULLIF(@company_volume, ''),
    `company_timely_rate` = NULLIF(@company_timely_rate, ''),
    `product_timely_rate` = NULLIF(@product_timely_rate, ''),
    `response_risk_score` = NULLIF(@response_risk_score, ''),
    `review_band` = NULLIF(TRIM(TRAILING '\r' FROM @review_band), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `complaint_id`)) AS distinct_source_keys FROM `consumer_complaints`;
