-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'facility_id', `facility_id`,
    'facility_name', `facility_name`,
    'state', `state`,
    'measure_name', `measure_name`,
    'number_of_discharges', `number_of_discharges`,
    'number_of_readmissions', `number_of_readmissions`,
    'excess_readmission_ratio', `excess_readmission_ratio`,
    'performance_band', `performance_band`,
    'rural_flag', `rural_flag`,
    'svi_percentile', `svi_percentile`,
    'reliability_weight', `reliability_weight`,
    'shrunk_readmission_ratio', `shrunk_readmission_ratio`,
    'excess_readmission_opportunity', `excess_readmission_opportunity`,
    'peer_gap_pp', `peer_gap_pp`,
    'priority_score', `priority_score`,
    'observed_rate', `observed_rate`,
    'peer_observed_rate', `peer_observed_rate`,
    'posterior_observed_rate', `posterior_observed_rate`,
    'observed_rate_credible_low', `observed_rate_credible_low`,
    'observed_rate_credible_high', `observed_rate_credible_high`
) AS row_json
FROM `p04_hospital_readmissions`
ORDER BY `sql_row_id`;
