-- Manual MySQL population for 05_drug_safety.
-- First run schema.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 05_drug_safety.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `p05_drug_safety`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/05_drug_safety.csv'
INTO TABLE `p05_drug_safety`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @record_id,
    @snapshot_date,
    @package_ndc,
    @generic_name,
    @company_name,
    @status,
    @availability,
    @availability_group,
    @therapeutic_category,
    @dosage_form,
    @presentation,
    @update_type,
    @initial_posting_date,
    @update_date,
    @shortage_age_days,
    @active_flag,
    @manufacturer_count,
    @single_source_flag,
    @category_active_count,
    @concentration_pressure,
    @escalation_score,
    @escalation_band
)
SET
    `record_id` = NULLIF(@record_id, ''),
    `snapshot_date` = NULLIF(@snapshot_date, ''),
    `package_ndc` = NULLIF(@package_ndc, ''),
    `generic_name` = NULLIF(@generic_name, ''),
    `company_name` = NULLIF(@company_name, ''),
    `status` = NULLIF(@status, ''),
    `availability` = NULLIF(@availability, ''),
    `availability_group` = NULLIF(@availability_group, ''),
    `therapeutic_category` = NULLIF(@therapeutic_category, ''),
    `dosage_form` = NULLIF(@dosage_form, ''),
    `presentation` = NULLIF(@presentation, ''),
    `update_type` = NULLIF(@update_type, ''),
    `initial_posting_date` = NULLIF(@initial_posting_date, ''),
    `update_date` = NULLIF(@update_date, ''),
    `shortage_age_days` = NULLIF(@shortage_age_days, ''),
    `active_flag` = NULLIF(@active_flag, ''),
    `manufacturer_count` = NULLIF(@manufacturer_count, ''),
    `single_source_flag` = NULLIF(@single_source_flag, ''),
    `category_active_count` = NULLIF(@category_active_count, ''),
    `concentration_pressure` = NULLIF(@concentration_pressure, ''),
    `escalation_score` = NULLIF(@escalation_score, ''),
    `escalation_band` = NULLIF(TRIM(TRAILING '\r' FROM @escalation_band), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `record_id`)) AS distinct_source_keys FROM `p05_drug_safety`;
