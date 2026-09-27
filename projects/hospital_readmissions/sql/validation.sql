-- Run after populate.sql for 04_hospital_readmissions; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `facility_id`, `measure_name`)) AS distinct_source_keys FROM `p04_hospital_readmissions`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_facility_id FROM `p04_hospital_readmissions` WHERE `facility_id` IS NULL OR `facility_id` = '';
SELECT COUNT(*) AS missing_measure_name FROM `p04_hospital_readmissions` WHERE `measure_name` IS NULL OR `measure_name` = '';
SELECT COUNT(`priority_score`) AS scored_records FROM `p04_hospital_readmissions`;
