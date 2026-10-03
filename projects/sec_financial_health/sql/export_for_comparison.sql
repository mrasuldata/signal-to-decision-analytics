-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'cert', `cert`,
    'bank_name', `bank_name`,
    'state', `state`,
    'report_date', `report_date`,
    'assets', `assets`,
    'deposits', `deposits`,
    'loans', `loans`,
    'equity', `equity`,
    'net_income', `net_income`,
    'noncurrent_loans', `noncurrent_loans`,
    'reported_roa_pct', `reported_roa_pct`,
    'uninsured_deposits', `uninsured_deposits`,
    'cre_loans', `cre_loans`,
    'cash_balances', `cash_balances`,
    'deposit_to_asset_pct', `deposit_to_asset_pct`,
    'loan_to_deposit_pct', `loan_to_deposit_pct`,
    'equity_to_asset_pct', `equity_to_asset_pct`,
    'noncurrent_loan_pct', `noncurrent_loan_pct`,
    'deposit_growth_yoy_pct', `deposit_growth_yoy_pct`,
    'uninsured_deposit_pct', `uninsured_deposit_pct`,
    'cre_to_asset_pct', `cre_to_asset_pct`,
    'composite_stress_score', `composite_stress_score`,
    'watchlist_band', `watchlist_band`,
    'deposit_growth_qoq_pct', `deposit_growth_qoq_pct`,
    'cash_to_asset_pct', `cash_to_asset_pct`,
    'asset_peer', `asset_peer`,
    'complete_peer_count', `complete_peer_count`,
    'funding_weight_score', `funding_weight_score`,
    'uninsured_cre_interaction', `uninsured_cre_interaction`,
    'latest_quarter_flag', `latest_quarter_flag`
) AS row_json
FROM `p03_bank_financial_health`
ORDER BY `sql_row_id`;
