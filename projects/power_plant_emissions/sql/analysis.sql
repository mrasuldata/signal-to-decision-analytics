-- Inspect stored notebook fields for 08_power_plant_emissions; this file does not recalculate the analysis.
USE portfolio7;
SELECT `plant_id`, `abatement_opportunity_tons` FROM `p08_power_plant_emissions` ORDER BY `sql_row_id` LIMIT 25;
