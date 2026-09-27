-- Run after populate.sql for 05_drug_safety; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `record_id`)) AS distinct_source_keys FROM `p05_drug_safety`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_record_id FROM `p05_drug_safety` WHERE `record_id` IS NULL OR `record_id` = '';
SELECT MIN(`snapshot_date`) AS first_period, MAX(`snapshot_date`) AS last_period FROM `p05_drug_safety`;
SELECT SUM(`status` = 'Current') AS current_records FROM `p05_drug_safety`;
