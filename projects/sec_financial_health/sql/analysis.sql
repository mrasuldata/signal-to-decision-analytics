-- Inspect stored notebook fields for 03_sec_financial_health; this file does not recalculate the analysis.
USE portfolio7;
SELECT `cert`, `report_date`, `latest_quarter_flag` FROM `p03_bank_financial_health` ORDER BY `sql_row_id` LIMIT 25;
