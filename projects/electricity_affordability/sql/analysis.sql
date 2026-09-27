-- Inspect stored notebook fields for 07_electricity_affordability; this file does not recalculate the analysis.
USE portfolio7;
SELECT `period`, `state`, `sector`, `load_pressure_flag` FROM `p07_electricity_affordability` ORDER BY `sql_row_id` LIMIT 25;
