-- MySQL 8 schema for the checked 08_power_plant_emissions Tableau extract.
-- These are stored notebook results; no calculation is replaced here.
CREATE DATABASE IF NOT EXISTS portfolio7 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE portfolio7;
CREATE TABLE IF NOT EXISTS `p08_power_plant_emissions` (
    `sql_row_id` BIGINT NOT NULL AUTO_INCREMENT,
    `plant_id` VARCHAR(32) NOT NULL,
    `plant_name` VARCHAR(64) NULL,
    `state` VARCHAR(32) NULL,
    `fuel` VARCHAR(32) NULL,
    `generation_mwh` DOUBLE NULL,
    `co2_tons` DOUBLE NULL,
    `nox_tons` DOUBLE NULL,
    `so2_tons` DOUBLE NULL,
    `co2_lb_mwh` DOUBLE NULL,
    `clean_generation_flag` TINYINT NULL,
    `abatement_opportunity_tons` DOUBLE NULL,
    `generation_share_pct` DOUBLE NULL,
    `transition_priority_score` DOUBLE NULL,
    `technology` VARCHAR(32) NULL,
    `peer_benchmark_tons_mwh` DOUBLE NULL,
    `peer_count` DOUBLE NULL,
    PRIMARY KEY (`sql_row_id`),
    UNIQUE KEY `unique_source_row` (`plant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
