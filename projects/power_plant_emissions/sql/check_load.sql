-- Run after load_extract.sql for 08_power_plant_emissions; compare with the dated quality report.
USE portfolio7;
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `plant_id`)) AS distinct_source_keys FROM `p08_power_plant_emissions`;
-- A zero result is required for each missing-key check below.
SELECT COUNT(*) AS missing_plant_id FROM `p08_power_plant_emissions` WHERE `plant_id` IS NULL OR `plant_id` = '';
SELECT COUNT(`abatement_opportunity_tons`) AS estimable_scenarios FROM `p08_power_plant_emissions`;
