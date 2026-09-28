-- Inspect stored notebook fields for 04_hospital_readmissions; this file does not recalculate the analysis.
USE portfolio7;
SELECT `facility_id`, `measure_name`, `priority_score` FROM `p04_hospital_readmissions` ORDER BY `sql_row_id` LIMIT 25;
