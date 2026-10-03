-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'record_id', `record_id`,
    'snapshot_date', `snapshot_date`,
    'package_ndc', `package_ndc`,
    'generic_name', `generic_name`,
    'company_name', `company_name`,
    'status', `status`,
    'availability', `availability`,
    'availability_group', `availability_group`,
    'therapeutic_category', `therapeutic_category`,
    'dosage_form', `dosage_form`,
    'presentation', `presentation`,
    'update_type', `update_type`,
    'initial_posting_date', `initial_posting_date`,
    'update_date', `update_date`,
    'shortage_age_days', `shortage_age_days`,
    'active_flag', `active_flag`,
    'manufacturer_count', `manufacturer_count`,
    'single_source_flag', `single_source_flag`,
    'category_active_count', `category_active_count`,
    'concentration_pressure', `concentration_pressure`,
    'escalation_score', `escalation_score`,
    'escalation_band', `escalation_band`
) AS row_json
FROM `p05_drug_safety`
ORDER BY `sql_row_id`;
