-- Inspect stored notebook fields for 05_drug_safety; this file does not recalculate the analysis.
USE portfolio7;
SELECT `record_id`, `snapshot_date`, `active_flag` FROM `p05_drug_safety` ORDER BY `sql_row_id` LIMIT 25;
