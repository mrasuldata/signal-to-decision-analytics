-- If secure_file_priv is empty, choose an administrator-approved server directory;
-- SQL NULL disables this import. See sql/README.md; never substitute an empty path.
-- Manual MySQL population for 10_semiconductor_supply_chain.
-- First run create_table.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 10_semiconductor_supply_chain.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `p10_semiconductor_supply_chain`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/10_semiconductor_supply_chain.csv'
INTO TABLE `p10_semiconductor_supply_chain`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @period,
    @series_id,
    @metric,
    @value,
    @unit,
    @source,
    @yoy_pct,
    @three_month_change_pct,
    @latest_flag,
    @momentum_band,
    @normalized_index,
    @pressure_zscore,
    @supply_pressure_flag
)
SET
    `period` = NULLIF(@period, ''),
    `series_id` = NULLIF(@series_id, ''),
    `metric` = NULLIF(@metric, ''),
    `value` = NULLIF(@value, ''),
    `unit` = NULLIF(@unit, ''),
    `source` = NULLIF(@source, ''),
    `yoy_pct` = NULLIF(@yoy_pct, ''),
    `three_month_change_pct` = NULLIF(@three_month_change_pct, ''),
    `latest_flag` = NULLIF(@latest_flag, ''),
    `momentum_band` = NULLIF(@momentum_band, ''),
    `normalized_index` = NULLIF(@normalized_index, ''),
    `pressure_zscore` = NULLIF(@pressure_zscore, ''),
    `supply_pressure_flag` = NULLIF(TRIM(TRAILING '\r' FROM @supply_pressure_flag), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `period`, `series_id`)) AS distinct_source_keys FROM `p10_semiconductor_supply_chain`;
