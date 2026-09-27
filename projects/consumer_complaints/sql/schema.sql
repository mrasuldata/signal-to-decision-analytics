-- MySQL 8 schema for the checked 01_consumer_complaints Tableau extract.
-- These are stored notebook results; no calculation is replaced here.
CREATE DATABASE IF NOT EXISTS portfolio7 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE portfolio7;
CREATE TABLE IF NOT EXISTS `consumer_complaints` (
    `sql_row_id` BIGINT NOT NULL AUTO_INCREMENT,
    `complaint_id` VARCHAR(32) NOT NULL,
    `date_received` DATETIME NULL,
    `date_sent` DATETIME NULL,
    `complaint_month` DATETIME NULL,
    `product` VARCHAR(32) NULL,
    `issue` VARCHAR(64) NULL,
    `company` VARCHAR(128) NULL,
    `state` VARCHAR(32) NULL,
    `submitted_via` VARCHAR(32) NULL,
    `company_response_to_consumer` VARCHAR(32) NULL,
    `days_to_send` BIGINT NULL,
    `timely_flag` TINYINT NULL,
    `disputed_flag` TINYINT NULL,
    `company_volume` BIGINT NULL,
    `company_timely_rate` DOUBLE NULL,
    `product_timely_rate` DOUBLE NULL,
    `response_risk_score` DOUBLE NULL,
    `review_band` VARCHAR(32) NULL,
    PRIMARY KEY (`sql_row_id`),
    UNIQUE KEY `unique_source_row` (`complaint_id`),
    KEY `idx_source_period` (`complaint_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
