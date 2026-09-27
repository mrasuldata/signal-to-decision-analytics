-- MySQL 8 schema for the checked 07_electricity_affordability Tableau extract.
-- These are stored notebook results; no calculation is replaced here.
CREATE DATABASE IF NOT EXISTS portfolio7 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE portfolio7;
CREATE TABLE IF NOT EXISTS `p07_electricity_affordability` (
    `sql_row_id` BIGINT NOT NULL AUTO_INCREMENT,
    `period` DATETIME NOT NULL,
    `state` VARCHAR(32) NOT NULL,
    `sector` VARCHAR(32) NOT NULL,
    `sales_mwh` DOUBLE NULL,
    `revenue_thousand` DOUBLE NULL,
    `customers` DOUBLE NULL,
    `avg_price_cents_kwh` DOUBLE NULL,
    `mwh_per_customer` DOUBLE NULL,
    `sales_yoy_pct` DOUBLE NULL,
    `price_yoy_pct` DOUBLE NULL,
    `rolling_peak_ratio` DOUBLE NULL,
    `data_center_market_flag` TINYINT NULL,
    `load_pressure_flag` TINYINT NULL,
    `attribution_note` VARCHAR(128) NULL,
    `load_pressure_index` DOUBLE NULL,
    `data_status` VARCHAR(32) NULL,
    `rolling_growth_3m` DOUBLE NULL,
    `seasonal_z` DOUBLE NULL,
    `quantity_log_growth_pp` DOUBLE NULL,
    `price_log_growth_pp` DOUBLE NULL,
    `revenue_log_growth_pp` DOUBLE NULL,
    PRIMARY KEY (`sql_row_id`),
    UNIQUE KEY `unique_source_row` (`period`, `state`, `sector`),
    KEY `idx_source_period` (`period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
