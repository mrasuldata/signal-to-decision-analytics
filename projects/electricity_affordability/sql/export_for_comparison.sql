-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'period', `period`,
    'state', `state`,
    'sector', `sector`,
    'sales_mwh', `sales_mwh`,
    'revenue_thousand', `revenue_thousand`,
    'customers', `customers`,
    'avg_price_cents_kwh', `avg_price_cents_kwh`,
    'mwh_per_customer', `mwh_per_customer`,
    'sales_yoy_pct', `sales_yoy_pct`,
    'price_yoy_pct', `price_yoy_pct`,
    'rolling_peak_ratio', `rolling_peak_ratio`,
    'data_center_market_flag', `data_center_market_flag`,
    'load_pressure_flag', `load_pressure_flag`,
    'attribution_note', `attribution_note`,
    'load_pressure_index', `load_pressure_index`,
    'data_status', `data_status`,
    'rolling_growth_3m', `rolling_growth_3m`,
    'seasonal_z', `seasonal_z`,
    'quantity_log_growth_pp', `quantity_log_growth_pp`,
    'price_log_growth_pp', `price_log_growth_pp`,
    'revenue_log_growth_pp', `revenue_log_growth_pp`
) AS row_json
FROM `p07_electricity_affordability`
ORDER BY `sql_row_id`;
