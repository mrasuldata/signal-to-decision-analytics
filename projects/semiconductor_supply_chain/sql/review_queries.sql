-- Inspect stored notebook fields for 10_semiconductor_supply_chain; this file does not recalculate the analysis.
USE portfolio7;
SELECT `period`, `series_id`, `latest_flag` FROM `p10_semiconductor_supply_chain` ORDER BY `sql_row_id` LIMIT 25;
