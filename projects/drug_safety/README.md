# Drug Safety

The [packaged Tableau shortage-review workbook](tableau/drug_safety.twbx) uses the pinned 2026-09-26 extract. Open it after running the manual notebook's Source → Check stages and compare 1,600 records, including 1,152 Current records. Its listing-level concentration is a registry screen, not a measure of patient harm or real-world supply. The workbook is not a live publisher feed.

Source: [FDA openFDA drug-shortages API](https://open.fda.gov/apis/drug/drugshortages/). Two pinned publisher response pages, with request metadata and digests, are in `data/raw/publisher_responses/`. The verified 2026-09-26 cleaned extract has **1,600 package records**.

Open [the manual notebook](notebooks/drug_safety_analysis.ipynb) from the portfolio folder. Run and inspect Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide in order. `data/manual_rebuild/2026-09-26/` contains the extract, quality report, source manifest, and analysis tables. The `Show` stage displays the concentration analysis; the analyst's decision must cite the dated evidence and a limit.

The existing method screens shortage age, therapeutic-category concentration, and record-level sensitivity. An openFDA record count is not patient exposure, clinical harm, product availability at a particular pharmacy, or a causal safety effect. Reporting and update dates can lag real-world events; category and NDC mapping deserve review before operational action.

After Check and Save, follow the [manual MySQL handoff](sql/README.md): run `create_table.sql`, `load_extract.sql`, `check_load.sql`, then `review_queries.sql` in Workbench. SQL loads and checks a mirror of this run's saved extract; it does not replace notebook calculations. MySQL is needed only for the SQL demonstration. This CSV has one quoted field containing a line break; validate the **1,600 logical records** after loading.
