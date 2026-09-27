# 04 Hospital Readmissions

The [packaged Tableau readmission-review workbook](tableau/04_hospital_readmissions.twbx) uses the pinned 2026-09-26 extract. Open it after running the manual notebook's Source → Check stages and compare 18,330 records, 8,022 scored records, and 232 lower-bound signals. The signals are not preventable-admission or savings estimates. The workbook is not a live publisher feed.

Source: [CMS Hospital Readmissions Reduction Program data](https://data.cms.gov/provider-data/dataset/9n3s-kdb3). The pinned publisher responses are in `data/raw/publisher_responses/`, with retrieval metadata and SHA-256 digests. The verified 2026-09-26 cleaned extract has **18,330 facility-measure rows**.

Open [the manual notebook](notebooks/manual_lineage.ipynb) from the portfolio folder. Run Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide one stage at a time. Inspect the row preview, quality checks, `observed_rate_uncertainty.csv`, and the saved extract in `data/manual_rebuild/2026-09-26/`. The notebook `Show` stage displays the uncertainty table. Its `Decide` cell records a bounded conclusion for the pinned response; revise it for any fresh response. The packaged Tableau evidence-review worksheet was tested with ten visible facility-measure rows.

The existing method compares hospital readmission measures with uncertainty and shrinkage sensitivity. This is a prioritization screen, not a causal estimate of care quality or a patient-level prediction. Measure definitions, case mix, small denominators, suppressed values, and public-reporting lag constrain interpretation. Do not equate a ranked facility with an avoidable admission count.

After Check and Save, follow the [manual MySQL handoff](sql/README.md): run `schema.sql`, `populate.sql`, `validation.sql`, then `analysis.sql` in Workbench. SQL loads and checks a mirror of this run's saved extract; it does not replace notebook calculations. MySQL is needed only for the SQL demonstration.
