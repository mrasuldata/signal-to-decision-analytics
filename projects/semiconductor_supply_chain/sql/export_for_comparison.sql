-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'period', `period`,
    'series_id', `series_id`,
    'metric', `metric`,
    'value', `value`,
    'unit', `unit`,
    'source', `source`,
    'yoy_pct', `yoy_pct`,
    'three_month_change_pct', `three_month_change_pct`,
    'latest_flag', `latest_flag`,
    'momentum_band', `momentum_band`,
    'normalized_index', `normalized_index`,
    'pressure_zscore', `pressure_zscore`,
    'supply_pressure_flag', `supply_pressure_flag`
) AS row_json
FROM `p10_semiconductor_supply_chain`
ORDER BY `sql_row_id`;
