-- MySQL 8 schema for the checked 10_semiconductor_supply_chain Tableau extract.
-- These are stored notebook results; no calculation is replaced here.
CREATE DATABASE IF NOT EXISTS portfolio7 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE portfolio7;
CREATE TABLE IF NOT EXISTS `p10_semiconductor_supply_chain` (
    `sql_row_id` BIGINT NOT NULL AUTO_INCREMENT,
    `period` DATETIME NOT NULL,
    `series_id` VARCHAR(32) NOT NULL,
    `metric` VARCHAR(64) NULL,
    `value` DOUBLE NULL,
    `unit` VARCHAR(32) NULL,
    `source` VARCHAR(32) NULL,
    `yoy_pct` DOUBLE NULL,
    `three_month_change_pct` DOUBLE NULL,
    `latest_flag` TINYINT NULL,
    `momentum_band` VARCHAR(32) NULL,
    `normalized_index` DOUBLE NULL,
    `pressure_zscore` DOUBLE NULL,
    `supply_pressure_flag` TINYINT NULL,
    PRIMARY KEY (`sql_row_id`),
    UNIQUE KEY `unique_source_row` (`period`, `series_id`),
    KEY `idx_source_period` (`period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
