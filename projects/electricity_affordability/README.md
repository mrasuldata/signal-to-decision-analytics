# 07 Electricity Affordability

The [packaged Tableau electricity-review workbook](tableau/07_electricity_affordability.twbx) uses the pinned 2026-09-26 extract. Open it after running the manual notebook's Source → Check stages and compare 275 state-month records and the July 2026 endpoint. Monthly sales growth does not establish hourly peak demand or the cause of a price change. The workbook is not a live publisher feed.

Source: [EIA electricity sales and revenue data](https://www.eia.gov/electricity/data.php). The exact pinned publisher workbook, response metadata, and SHA-256 digest are in `data/raw/publisher_responses/`. The verified 2026-09-26 cleaned extract has **275 state-period rows**.

Open [the manual notebook](notebooks/manual_lineage.ipynb) from the portfolio folder. Execute Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide stage by stage, checking each preview, calculation, and assertion. The dated `data/manual_rebuild/2026-09-26/` folder holds the quality report, source manifest, extract, and analysis tables. The `Show` stage displays monthly pressure signals; any decision must cite those outputs and a limit.

The existing analysis uses revenue, sales, growth, and persistence scenarios to flag possible pressure. Average revenue per unit is not an individual household's bill or an income-adjusted affordability measure. The screening analysis does not establish the cause of changes or forecast policy outcomes. Seasonal, customer-mix, and reporting differences matter.

After Check and Save, follow the [manual MySQL handoff](sql/README.md): run `schema.sql`, `populate.sql`, `validation.sql`, then `analysis.sql` in Workbench. SQL loads and checks a mirror of this run's saved extract; it does not replace notebook calculations. MySQL is needed only for the SQL demonstration.
