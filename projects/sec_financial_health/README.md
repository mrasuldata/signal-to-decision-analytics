# 03 Bank Financial Health

The [packaged Tableau bank-monitor workbook](tableau/03_sec_financial_health.twbx) uses the pinned 2026-09-26 extract. Open it after running the manual notebook's Source → Check stages and compare the latest-quarter count (159 banks), scored count (148), and default-threshold review count (2). A review score is a screening signal, not a probability of failure. The workbook is not a live publisher feed.

Source: [FDIC BankFind financials API](https://banks.data.fdic.gov/docs/). The notebook requests the defined 2023-Q1 to 2025-Q4 quarter range for banks meeting its asset threshold. The pinned 2026-09-26 publisher response and its digest are under `data/raw/publisher_responses/`; the verified cleaned extract contains **1,935 bank-quarter rows**.

Open [the manual notebook](notebooks/manual_lineage.ipynb) from the portfolio folder and perform Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide, inspecting the output and check at each stage. The dated `data/manual_rebuild/2026-09-26/` folder contains the quality report, source manifest, extract, and analysis tables. The `Show` stage displays the deposit-outflow scenario; cite that and the quality report in the analyst's decision.

The existing method uses calendar-aligned deposit changes, reported balance-sheet ratios, fixed asset-size peer groups, complete-case peer rankings, and a stress *screen*. FDIC monetary inputs are thousands of dollars. Scenario and score outputs are not default probabilities or causal forecasts. Peer composition, reporting revisions, and missing values limit comparisons; an escalation still needs institution-specific review.

After Check and Save, follow the [manual MySQL handoff](sql/README.md): run `schema.sql`, `populate.sql`, `validation.sql`, then `analysis.sql` in Workbench. SQL loads and checks a mirror of this run's saved extract; it does not replace notebook calculations. MySQL is needed only for the SQL demonstration.
