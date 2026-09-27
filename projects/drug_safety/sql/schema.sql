-- MySQL 8 schema for the checked 05_drug_safety Tableau extract.
-- These are stored notebook results; no calculation is replaced here.
CREATE DATABASE IF NOT EXISTS portfolio7 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE portfolio7;
CREATE TABLE IF NOT EXISTS `p05_drug_safety` (
    `sql_row_id` BIGINT NOT NULL AUTO_INCREMENT,
    `record_id` VARCHAR(80) NOT NULL,
    `snapshot_date` DATETIME NULL,
    `package_ndc` VARCHAR(32) NULL,
    `generic_name` VARCHAR(256) NULL,
    `company_name` VARCHAR(128) NULL,
    `status` VARCHAR(32) NULL,
    `availability` VARCHAR(32) NULL,
    `availability_group` VARCHAR(32) NULL,
    `therapeutic_category` VARCHAR(256) NULL,
    `dosage_form` VARCHAR(32) NULL,
    `presentation` VARCHAR(512) NULL,
    `update_type` VARCHAR(32) NULL,
    `initial_posting_date` DATETIME NULL,
    `update_date` DATETIME NULL,
    `shortage_age_days` DOUBLE NULL,
    `active_flag` TINYINT NULL,
    `manufacturer_count` DOUBLE NULL,
    `single_source_flag` TINYINT NULL,
    `category_active_count` BIGINT NULL,
    `concentration_pressure` DOUBLE NULL,
    `escalation_score` DOUBLE NULL,
    `escalation_band` VARCHAR(32) NULL,
    PRIMARY KEY (`sql_row_id`),
    UNIQUE KEY `unique_source_row` (`record_id`),
    KEY `idx_source_period` (`snapshot_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
