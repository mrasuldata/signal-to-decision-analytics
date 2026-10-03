-- Read-only full-row export; the JSON preserves SQL nulls and text IDs.
-- In Workbench, disable the result-row limit before executing this SELECT.
-- Export its complete result grid as UTF-8 CSV, including the row_json header.
-- Keep the export local; do not commit it. Follow sql/README.md for comparison.
USE portfolio7;
SELECT JSON_OBJECT(
    'plant_id', `plant_id`,
    'plant_name', `plant_name`,
    'state', `state`,
    'fuel', `fuel`,
    'generation_mwh', `generation_mwh`,
    'co2_tons', `co2_tons`,
    'nox_tons', `nox_tons`,
    'so2_tons', `so2_tons`,
    'co2_lb_mwh', `co2_lb_mwh`,
    'clean_generation_flag', `clean_generation_flag`,
    'abatement_opportunity_tons', `abatement_opportunity_tons`,
    'generation_share_pct', `generation_share_pct`,
    'transition_priority_score', `transition_priority_score`,
    'technology', `technology`,
    'peer_benchmark_tons_mwh', `peer_benchmark_tons_mwh`,
    'peer_count', `peer_count`
) AS row_json
FROM `p08_power_plant_emissions`
ORDER BY `sql_row_id`;
