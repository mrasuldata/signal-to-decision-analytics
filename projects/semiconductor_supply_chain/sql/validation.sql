-- Run after populate.sql for 10_semiconductor_supply_chain; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `period`, `series_id`)) AS distinct_source_keys FROM `p10_semiconductor_supply_chain`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_period FROM `p10_semiconductor_supply_chain` WHERE `period` IS NULL;
SELECT COUNT(*) AS missing_series_id FROM `p10_semiconductor_supply_chain` WHERE `series_id` IS NULL OR `series_id` = '';
SELECT MIN(`period`) AS first_period, MAX(`period`) AS last_period FROM `p10_semiconductor_supply_chain`;
SELECT `series_id`, COUNT(*) AS observations, MAX(`period`) AS latest_period FROM `p10_semiconductor_supply_chain` GROUP BY `series_id` ORDER BY `series_id`;
