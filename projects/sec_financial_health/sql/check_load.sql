-- Run after load_extract.sql for 03_sec_financial_health; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `cert`, `report_date`)) AS distinct_source_keys FROM `p03_bank_financial_health`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_cert FROM `p03_bank_financial_health` WHERE `cert` IS NULL OR `cert` = '';
SELECT COUNT(*) AS missing_report_date FROM `p03_bank_financial_health` WHERE `report_date` IS NULL;
SELECT MIN(`report_date`) AS first_period, MAX(`report_date`) AS last_period FROM `p03_bank_financial_health`;
SELECT SUM(`latest_quarter_flag` = 1) AS latest_banks, SUM(`latest_quarter_flag` = 1 AND `composite_stress_score` IS NOT NULL) AS latest_scored FROM `p03_bank_financial_health`;
