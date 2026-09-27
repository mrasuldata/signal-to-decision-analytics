-- Manual MySQL population for 04_hospital_readmissions.
-- First run schema.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 04_hospital_readmissions.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `p04_hospital_readmissions`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/04_hospital_readmissions.csv'
INTO TABLE `p04_hospital_readmissions`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @facility_id,
    @facility_name,
    @state,
    @measure_name,
    @number_of_discharges,
    @number_of_readmissions,
    @excess_readmission_ratio,
    @performance_band,
    @rural_flag,
    @svi_percentile,
    @reliability_weight,
    @shrunk_readmission_ratio,
    @excess_readmission_opportunity,
    @peer_gap_pp,
    @priority_score,
    @observed_rate,
    @peer_observed_rate,
    @posterior_observed_rate,
    @observed_rate_credible_low,
    @observed_rate_credible_high
)
SET
    `facility_id` = NULLIF(@facility_id, ''),
    `facility_name` = NULLIF(@facility_name, ''),
    `state` = NULLIF(@state, ''),
    `measure_name` = NULLIF(@measure_name, ''),
    `number_of_discharges` = NULLIF(@number_of_discharges, ''),
    `number_of_readmissions` = NULLIF(@number_of_readmissions, ''),
    `excess_readmission_ratio` = NULLIF(@excess_readmission_ratio, ''),
    `performance_band` = NULLIF(@performance_band, ''),
    `rural_flag` = NULLIF(@rural_flag, ''),
    `svi_percentile` = NULLIF(@svi_percentile, ''),
    `reliability_weight` = NULLIF(@reliability_weight, ''),
    `shrunk_readmission_ratio` = NULLIF(@shrunk_readmission_ratio, ''),
    `excess_readmission_opportunity` = NULLIF(@excess_readmission_opportunity, ''),
    `peer_gap_pp` = NULLIF(@peer_gap_pp, ''),
    `priority_score` = NULLIF(@priority_score, ''),
    `observed_rate` = NULLIF(@observed_rate, ''),
    `peer_observed_rate` = NULLIF(@peer_observed_rate, ''),
    `posterior_observed_rate` = NULLIF(@posterior_observed_rate, ''),
    `observed_rate_credible_low` = NULLIF(@observed_rate_credible_low, ''),
    `observed_rate_credible_high` = NULLIF(TRIM(TRAILING '\r' FROM @observed_rate_credible_high), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `facility_id`, `measure_name`)) AS distinct_source_keys FROM `p04_hospital_readmissions`;
