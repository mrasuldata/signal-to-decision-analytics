-- Run after populate.sql for 07_electricity_affordability; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `period`, `state`, `sector`)) AS distinct_source_keys FROM `p07_electricity_affordability`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_period FROM `p07_electricity_affordability` WHERE `period` IS NULL;
SELECT COUNT(*) AS missing_state FROM `p07_electricity_affordability` WHERE `state` IS NULL OR `state` = '';
SELECT COUNT(*) AS missing_sector FROM `p07_electricity_affordability` WHERE `sector` IS NULL OR `sector` = '';
SELECT MIN(`period`) AS first_period, MAX(`period`) AS last_period FROM `p07_electricity_affordability`;
SELECT `state`, COUNT(*) AS state_period_rows FROM `p07_electricity_affordability` GROUP BY `state` ORDER BY `state`;
