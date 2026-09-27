# 08 Power Plant Emissions

The [packaged Tableau emissions-screen workbook](tableau/08_power_plant_emissions.twbx) uses the pinned 2026-09-26 extract. Open it after running the manual notebook's Source → Check stages and compare 12,612 plants and 3,233 estimable scenarios. The modeled opportunity is a scenario, not a promise of attainable savings. The workbook is not a live publisher feed.

Source: [EPA eGRID](https://www.epa.gov/egrid). The exact pinned eGRID publisher workbook, retrieval metadata, and SHA-256 digest are in `data/raw/publisher_responses/`. The verified 2026-09-26 cleaned extract has **12,612 plant rows**.

Open [the manual notebook](notebooks/manual_lineage.ipynb) from the portfolio folder. Work through Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide one visible stage at a time. The dated `data/manual_rebuild/2026-09-26/` folder includes the quality report, source manifest, extract, and analysis tables. The `Show` stage displays the abatement Pareto table; cite it and its checks in the analyst's decision.

The existing method compares plant emissions intensity with fuel/peer scenarios and ranks hypothetical abatement opportunity. The scenario is not an engineered retrofit estimate, dispatch forecast, or realized emissions reduction. Plants with missing generation or emissions cannot support every intensity calculation; fuel, technology, and reporting-year differences limit comparisons.

After Check and Save, follow the [manual MySQL handoff](sql/README.md): run `schema.sql`, `populate.sql`, `validation.sql`, then `analysis.sql` in Workbench. SQL loads and checks a mirror of this run's saved extract; it does not replace notebook calculations. MySQL is needed only for the SQL demonstration.
