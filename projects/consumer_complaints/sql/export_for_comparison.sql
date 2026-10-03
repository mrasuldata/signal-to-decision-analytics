-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'complaint_id', `complaint_id`,
    'date_received', `date_received`,
    'date_sent', `date_sent`,
    'complaint_month', `complaint_month`,
    'product', `product`,
    'issue', `issue`,
    'company', `company`,
    'state', `state`,
    'submitted_via', `submitted_via`,
    'company_response_to_consumer', `company_response_to_consumer`,
    'days_to_send', `days_to_send`,
    'timely_flag', `timely_flag`,
    'disputed_flag', `disputed_flag`,
    'company_volume', `company_volume`,
    'company_timely_rate', `company_timely_rate`,
    'product_timely_rate', `product_timely_rate`,
    'response_risk_score', `response_risk_score`,
    'review_band', `review_band`
) AS row_json
FROM `consumer_complaints`
ORDER BY `sql_row_id`;
