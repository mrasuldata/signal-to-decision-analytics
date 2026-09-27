-- Manual MySQL population for 03_sec_financial_health.
-- First run schema.sql. Stage the checked tableau_extract.csv in the
-- directory returned by SELECT @@secure_file_priv; rename its COPY to
-- 03_sec_financial_health.csv. Edit only a temporary copy of this SQL file: replace
-- __MYSQL_SECURE_FILE_PRIV__ with that directory, using forward slashes.
-- The account needs FILE privilege. Do not commit the edited copy.
-- TRUNCATE replaces only this project's SQL mirror, not the saved CSV.
USE portfolio7;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
TRUNCATE TABLE `p03_bank_financial_health`;
LOAD DATA INFILE '__MYSQL_SECURE_FILE_PRIV__/03_sec_financial_health.csv'
INTO TABLE `p03_bank_financial_health`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @cert,
    @bank_name,
    @state,
    @report_date,
    @assets,
    @deposits,
    @loans,
    @equity,
    @net_income,
    @noncurrent_loans,
    @reported_roa_pct,
    @uninsured_deposits,
    @cre_loans,
    @cash_balances,
    @deposit_to_asset_pct,
    @loan_to_deposit_pct,
    @equity_to_asset_pct,
    @noncurrent_loan_pct,
    @deposit_growth_yoy_pct,
    @uninsured_deposit_pct,
    @cre_to_asset_pct,
    @composite_stress_score,
    @watchlist_band,
    @deposit_growth_qoq_pct,
    @cash_to_asset_pct,
    @asset_peer,
    @complete_peer_count,
    @funding_weight_score,
    @uninsured_cre_interaction,
    @latest_quarter_flag
)
SET
    `cert` = NULLIF(@cert, ''),
    `bank_name` = NULLIF(@bank_name, ''),
    `state` = NULLIF(@state, ''),
    `report_date` = NULLIF(@report_date, ''),
    `assets` = NULLIF(@assets, ''),
    `deposits` = NULLIF(@deposits, ''),
    `loans` = NULLIF(@loans, ''),
    `equity` = NULLIF(@equity, ''),
    `net_income` = NULLIF(@net_income, ''),
    `noncurrent_loans` = NULLIF(@noncurrent_loans, ''),
    `reported_roa_pct` = NULLIF(@reported_roa_pct, ''),
    `uninsured_deposits` = NULLIF(@uninsured_deposits, ''),
    `cre_loans` = NULLIF(@cre_loans, ''),
    `cash_balances` = NULLIF(@cash_balances, ''),
    `deposit_to_asset_pct` = NULLIF(@deposit_to_asset_pct, ''),
    `loan_to_deposit_pct` = NULLIF(@loan_to_deposit_pct, ''),
    `equity_to_asset_pct` = NULLIF(@equity_to_asset_pct, ''),
    `noncurrent_loan_pct` = NULLIF(@noncurrent_loan_pct, ''),
    `deposit_growth_yoy_pct` = NULLIF(@deposit_growth_yoy_pct, ''),
    `uninsured_deposit_pct` = NULLIF(@uninsured_deposit_pct, ''),
    `cre_to_asset_pct` = NULLIF(@cre_to_asset_pct, ''),
    `composite_stress_score` = NULLIF(@composite_stress_score, ''),
    `watchlist_band` = NULLIF(@watchlist_band, ''),
    `deposit_growth_qoq_pct` = NULLIF(@deposit_growth_qoq_pct, ''),
    `cash_to_asset_pct` = NULLIF(@cash_to_asset_pct, ''),
    `asset_peer` = NULLIF(@asset_peer, ''),
    `complete_peer_count` = NULLIF(@complete_peer_count, ''),
    `funding_weight_score` = NULLIF(@funding_weight_score, ''),
    `uninsured_cre_interaction` = NULLIF(@uninsured_cre_interaction, ''),
    `latest_quarter_flag` = NULLIF(TRIM(TRAILING '\r' FROM @latest_quarter_flag), '');
-- Inspect load warnings before another statement replaces them.
SHOW WARNINGS LIMIT 10;
-- Compare this with the current run's quality_report.json, not an old snapshot.
SELECT COUNT(*) AS loaded_rows, COUNT(DISTINCT CONCAT_WS('|', `cert`, `report_date`)) AS distinct_source_keys FROM `p03_bank_financial_health`;
