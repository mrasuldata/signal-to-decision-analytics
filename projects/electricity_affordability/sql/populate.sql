-- Manual MySQL population for 07_electricity_affordability.
-- First run schema.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 07_electricity_affordability.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `p07_electricity_affordability`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/07_electricity_affordability.csv'
INTO TABLE `p07_electricity_affordability`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @period,
    @state,
    @sector,
    @sales_mwh,
    @revenue_thousand,
    @customers,
    @avg_price_cents_kwh,
    @mwh_per_customer,
    @sales_yoy_pct,
    @price_yoy_pct,
    @rolling_peak_ratio,
    @data_center_market_flag,
    @load_pressure_flag,
    @attribution_note,
    @load_pressure_index,
    @data_status,
    @rolling_growth_3m,
    @seasonal_z,
    @quantity_log_growth_pp,
    @price_log_growth_pp,
    @revenue_log_growth_pp
)
SET
    `period` = NULLIF(@period, ''),
    `state` = NULLIF(@state, ''),
    `sector` = NULLIF(@sector, ''),
    `sales_mwh` = NULLIF(@sales_mwh, ''),
    `revenue_thousand` = NULLIF(@revenue_thousand, ''),
    `customers` = NULLIF(@customers, ''),
    `avg_price_cents_kwh` = NULLIF(@avg_price_cents_kwh, ''),
    `mwh_per_customer` = NULLIF(@mwh_per_customer, ''),
    `sales_yoy_pct` = NULLIF(@sales_yoy_pct, ''),
    `price_yoy_pct` = NULLIF(@price_yoy_pct, ''),
    `rolling_peak_ratio` = NULLIF(@rolling_peak_ratio, ''),
    `data_center_market_flag` = NULLIF(@data_center_market_flag, ''),
    `load_pressure_flag` = NULLIF(@load_pressure_flag, ''),
    `attribution_note` = NULLIF(@attribution_note, ''),
    `load_pressure_index` = NULLIF(@load_pressure_index, ''),
    `data_status` = NULLIF(@data_status, ''),
    `rolling_growth_3m` = NULLIF(@rolling_growth_3m, ''),
    `seasonal_z` = NULLIF(@seasonal_z, ''),
    `quantity_log_growth_pp` = NULLIF(@quantity_log_growth_pp, ''),
    `price_log_growth_pp` = NULLIF(@price_log_growth_pp, ''),
    `revenue_log_growth_pp` = NULLIF(TRIM(TRAILING '\r' FROM @revenue_log_growth_pp), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `period`, `state`, `sector`)) AS distinct_source_keys FROM `p07_electricity_affordability`;
