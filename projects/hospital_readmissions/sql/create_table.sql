-- MySQL 8 schema for the checked 04_hospital_readmissions Tableau extract.
-- These are stored notebook results; no calculation is replaced here.
CREATE DATABASE IF NOT EXISTS portfolio7 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE portfolio7;
CREATE TABLE IF NOT EXISTS `p04_hospital_readmissions` (
    `sql_row_id` BIGINT NOT NULL AUTO_INCREMENT,
    `facility_id` VARCHAR(32) NOT NULL,
    `facility_name` VARCHAR(128) NULL,
    `state` VARCHAR(32) NULL,
    `measure_name` VARCHAR(32) NOT NULL,
    `number_of_discharges` DOUBLE NULL,
    `number_of_readmissions` DOUBLE NULL,
    `excess_readmission_ratio` DOUBLE NULL,
    `performance_band` VARCHAR(32) NULL,
    `rural_flag` TINYINT NULL,
    `svi_percentile` DOUBLE NULL,
    `reliability_weight` DOUBLE NULL,
    `shrunk_readmission_ratio` DOUBLE NULL,
    `excess_readmission_opportunity` DOUBLE NULL,
    `peer_gap_pp` DOUBLE NULL,
    `priority_score` DOUBLE NULL,
    `observed_rate` DOUBLE NULL,
    `peer_observed_rate` DOUBLE NULL,
    `posterior_observed_rate` DOUBLE NULL,
    `observed_rate_credible_low` DOUBLE NULL,
    `observed_rate_credible_high` DOUBLE NULL,
    PRIMARY KEY (`sql_row_id`),
    UNIQUE KEY `unique_source_row` (`facility_id`, `measure_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
