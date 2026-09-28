# Semiconductor Supply Chain

The [packaged Tableau economic-pulse workbook](tableau/semiconductor_supply_chain.twbx) uses the pinned 2026-09-26 extract. Open it after running the manual notebook's Source → Check stages and compare 95 series-month observations. Each series has its own publication lag; the mixed indicators do not establish a supply squeeze. The workbook is not a live publisher feed.

Source: [BLS public time-series data](https://www.bls.gov/developers/api_signature_v2.htm). Three pinned publisher responses, their request metadata, and SHA-256 digests are in `data/raw/publisher_responses/`. The verified 2026-09-26 cleaned extract has **95 series-period rows**.

Open [the manual notebook](notebooks/semiconductor_supply_chain_analysis.ipynb) from the portfolio folder. Execute Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide in order, checking each visible preview and validation. The dated `data/manual_rebuild/2026-09-26/` folder holds the source manifest, quality report, extract, and analysis tables. The `Show` stage displays divergence analysis; cite it and the checks in the analyst's decision.

The existing method aligns selected BLS semiconductor-related series, growth and momentum screens, and lead/lag diagnostics. These are descriptive indicators, not a direct inventory measure or a validated causal supply-chain forecast. Series definitions, revisions, base periods, and lag-screen uncertainty limit conclusions.

After Check and Save, follow the [manual MySQL handoff](sql/README.md): run `create_table.sql`, `load_extract.sql`, `check_load.sql`, then `review_queries.sql` in Workbench. SQL loads and checks a mirror of this run's saved extract; it does not replace notebook calculations. MySQL is needed only for the SQL demonstration.
