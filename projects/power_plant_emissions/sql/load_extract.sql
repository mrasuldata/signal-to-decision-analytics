-- Manual MySQL population for 08_power_plant_emissions.
-- First run create_table.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 08_power_plant_emissions.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `p08_power_plant_emissions`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/08_power_plant_emissions.csv'
INTO TABLE `p08_power_plant_emissions`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @plant_id,
    @plant_name,
    @state,
    @fuel,
    @generation_mwh,
    @co2_tons,
    @nox_tons,
    @so2_tons,
    @co2_lb_mwh,
    @clean_generation_flag,
    @abatement_opportunity_tons,
    @generation_share_pct,
    @transition_priority_score,
    @technology,
    @peer_benchmark_tons_mwh,
    @peer_count
)
SET
    `plant_id` = NULLIF(@plant_id, ''),
    `plant_name` = NULLIF(@plant_name, ''),
    `state` = NULLIF(@state, ''),
    `fuel` = NULLIF(@fuel, ''),
    `generation_mwh` = NULLIF(@generation_mwh, ''),
    `co2_tons` = NULLIF(@co2_tons, ''),
    `nox_tons` = NULLIF(@nox_tons, ''),
    `so2_tons` = NULLIF(@so2_tons, ''),
    `co2_lb_mwh` = NULLIF(@co2_lb_mwh, ''),
    `clean_generation_flag` = NULLIF(@clean_generation_flag, ''),
    `abatement_opportunity_tons` = NULLIF(@abatement_opportunity_tons, ''),
    `generation_share_pct` = NULLIF(@generation_share_pct, ''),
    `transition_priority_score` = NULLIF(@transition_priority_score, ''),
    `technology` = NULLIF(@technology, ''),
    `peer_benchmark_tons_mwh` = NULLIF(@peer_benchmark_tons_mwh, ''),
    `peer_count` = NULLIF(TRIM(TRAILING '\r' FROM @peer_count), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `plant_id`)) AS distinct_source_keys FROM `p08_power_plant_emissions`;
