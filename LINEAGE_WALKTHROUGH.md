# Reproduce the seven analyses, step by step

This is the interview walkthrough for a person who has only this GitHub repository or the ZIP. The CDC NORS project supplied the **lineage pattern and manual SQL handoff**, not the fields or analytical methods for these seven analyses. The calculation flow is visible in each project's named analysis notebook under `notebooks/`; no `.py` module, launcher, configuration file, or background job is needed. Each `sql/` folder contains scripts to create the table, load the extract, check the load, and review results. MySQL is a manual second check of saved notebook results, not a prerequisite for calculating them.

## Choose the run you are demonstrating

1. **Exact saved-result replay (recommended for an interview):** extract the ZIP or download the repository, leave `USE_PINNED_RAW = True` in the notebook's **Source** code cell, and work through the cells in order. The publisher response bytes are included under that project's `data/raw/publisher_responses/`. The Source/Import code checks their SHA-256 values. The resulting figures should match the dated `data/manual_rebuild/2026-09-26/` files.
2. **New publisher download:** change only `USE_PINNED_RAW = False` in the **Source** code cell, then run **Import** to make the request and preserve its response bytes, request details, retrieval time, and SHA-256. Continue through all stages. This is a *new* run: current rows, metrics, and conclusions may differ from the 2026-09-26 snapshot. Save writes a separate dated/digest-suffixed rebuild when necessary. Do not claim that a new response reproduces the old figures or that the packaged Tableau workbook refreshed itself.

The pinned replay needs no Internet connection. A new download needs the publisher service to be available and may encounter a changed schema or access limit. In that case, stop and document the failure; do not silently substitute a different source or edit the formulas. See [source reuse](SOURCE_REUSE.md) before sharing new source material. The reuse review concerns the analyzed data; API access terms and non-endorsement still apply.

## Start with a clean copy

Use Python 3.13 and the packages listed in [README](README.md). Open a terminal at the **portfolio root** (the folder containing `projects/`), run `jupyter lab`, and open a project's named analysis notebook under `notebooks/`. Keep the notebook's code cells in their supplied order. Run **one code cell at a time**, read its output, and apply the gate below before advancing. Do not use Jupyter's **Run All** for an interview demonstration. The notebook finds its project from the portfolio root, so it does not need a machine-specific file path.

For an exact replay, work on a fresh copy of the ZIP/repository if you want to compare saved files byte for byte without changing your working copy. The supplied dated results are evidence, not a substitute for executing the notebook yourself. Do not commit personal environments, notebook checkpoints, temporary files, or newly downloaded responses until you have reviewed what they contain.

## The eight visible stages

Each heading below matches a Markdown instruction cell and its immediately following code cell in every project analysis notebook. The notebook's stage code is the corresponding implementation; the `Check` stage adds formal assertions. A manual gate at each stage is also necessary because a technically valid file can still represent the wrong question or cohort.

| Stage | What the analyst does in the notebook | Visible evidence | Gate before continuing |
|---|---|---|---|
| **1 Source** | Read the publisher URL, selection, grain, pinned digest, and the `USE_PINNED_RAW` choice in `source-code`. | Printed publisher, query/selection, project-relative location, and expected SHA-256. | The publisher and requested population match the project's README. For a new download, deliberately switch modes *before* Import. |
| **2 Import** | Run `import-code`. It verifies the pinned bytes or requests and preserves a fresh publisher response, then parses it. | Source date, response digest, imported row/column count, and a three-row preview. | No download, digest, parsing, empty-data, required-field, or cohort error. Verify the displayed source date. Project-specific exclusions (for example the CFPB date boundary) are printed. |
| **3 Transform and clean** | Run `clean-code`, which contains the project's transformation and record-grain rules. | Clean row/column count and a preview of standardized fields. | The unit of a row, key, field types, missing values, and any exclusions make sense. Stop on an unexplained loss of records or changed meaning. |
| **4 Calculate** | Run `calculate-code`, which contains the project's existing formulas and named analysis tables. | A printed table-name-to-row-count map and a preview of the principal result. | The named result is nonempty; denominators, units, time windows, signs, and labels agree with the project README. Do not interpret a screening score as a probability. |
| **5 Check** | Run `check-code`, including its assertions and `profile` quality report. | Current source/clean counts and the printed `passed` flag with notes. | Every assertion passes and `passed` is `true`. Investigate missing or duplicate keys, invalid values, and material row-count changes before Save. |
| **6 Save** | Run `save-code` only after Check. It writes the dated extract, source manifest, quality report, and analysis tables. Then perform the manual MySQL handoff below if demonstrating SQL. | Printed output folder, saved files, and Workbench query results. | Open `quality_report.json`, `source_manifest.json`, `tableau_extract.csv`, and the named analysis CSV. Confirm their date, digest, row count, and that no prior pinned result was replaced. If loading MySQL, its row and key counts must agree before Show. |
| **7 Show** | Run `show-code` to display the result table, then open the packaged `.twbx` for the **pinned** run if Tableau is available. | Notebook table plus a dated, embedded Tableau extract/dashboard. | Trace one displayed value to the saved analysis CSV or extract; check workbook filters and source date. A newly acquired response needs a deliberate Tableau refresh and caption review before display. |
| **8 Decide** | Read the limitations in the project README. Review the pinned, evidence-based `DECISION_TEXT` and `INTERPRETATION_LIMIT` in `decide-code`; revise them for any fresh response, then run the cell. | Printed source date, evidence-file names, decision, and limitation. | The code requires a passed quality report, nonblank decision and limit, and existing evidence files. State a bounded review action, not a causal, clinical, or predictive claim unsupported by these data. |

The supplied `Decide` cells contain decisions for the pinned response. Treat them as examples to defend or revise, not conclusions that automatically carry over to a newly downloaded response.

## Manual MySQL handoff after Save

This follows the CDC reference's `create_table.sql` → `load_extract.sql` → `check_load.sql` → `review_queries.sql` order. It is a visible, analyst-operated database mirror of the checked `tableau_extract.csv`. The notebook remains the owner of cleaning and calculations. The SQL files do not recreate those formulas or fetch source data. You can finish the notebook and Tableau demonstration without MySQL, but do not claim the SQL part was executed unless you actually ran and checked it.

1. In MySQL Workbench, connect to your local MySQL 8 server and run `SELECT @@secure_file_priv;`. This returns the server-approved upload directory. If it returns `NULL`, stop the SQL demonstration; do not weaken server security settings for this portfolio. Server-side loading also requires the account's `FILE` privilege.
2. Finish **Source → Import → Transform and clean → Calculate → Check → Save** in one project notebook. Open that run's `quality_report.json` and confirm `passed: true`. Note its row count and the exact run folder. A fresh response can have different numbers from the pinned run.
3. Copy that run's `tableau_extract.csv` into the directory returned in step 1. Rename **only the copy** to the project filename listed below. Do not edit the saved extract or the publisher response.
4. Open the project's `sql/create_table.sql` in a text editor. Copy all, paste into a Workbench SQL tab, and execute. Confirm the `portfolio7` schema and the project's table appear. Each project has its own table inside this one schema.
5. Make a temporary copy of `sql/load_extract.sql` **outside the repository**. In that temporary copy, replace `__MYSQL_SECURE_FILE_PRIV__` with the directory from step 1, using forward slashes. Copy its contents into Workbench and execute. The script truncates only this project's SQL mirror before loading, so a previous run cannot leave stale rows. Never commit the path-edited copy.
6. Read the Workbench warning output. Then execute `sql/check_load.sql`. Loaded rows must equal both the logical CSV record count and `quality_report.json`'s `rows` for this exact run. Distinct source keys must equal loaded rows; missing-key counts must be zero. Check the project-specific query result against its README and saved CSV. A successful load message without these comparisons is insufficient.
7. Execute `sql/review_queries.sql` to inspect stored notebook fields. Project 01 also contains the pre-existing response-queue SQL method cross-check. SQL queries are supporting evidence; the saved notebook results and Tableau extract remain unchanged.
8. Remove your temporary path-edited SQL copy and any staged server copy when finished, following your local database policy. Do not upload either to GitHub. Continue to **Show → Decide** only after identifying which parts you actually ran.

| Project | Staged CSV copy name | MySQL table | Pinned expected rows |
|---|---|---|---:|
| 01 Consumer Complaints | `01_consumer_complaints.csv` | `consumer_complaints` | 6,558 |
| 03 Bank Financial Health | `03_sec_financial_health.csv` | `p03_bank_financial_health` | 1,935 |
| 04 Hospital Readmissions | `04_hospital_readmissions.csv` | `p04_hospital_readmissions` | 18,330 |
| 05 Drug Safety | `05_drug_safety.csv` | `p05_drug_safety` | 1,600 |
| 07 Electricity Affordability | `07_electricity_affordability.csv` | `p07_electricity_affordability` | 275 |
| 08 Power Plant Emissions | `08_power_plant_emissions.csv` | `p08_power_plant_emissions` | 12,612 |
| 10 Semiconductor Supply Chain | `10_semiconductor_supply_chain.csv` | `p10_semiconductor_supply_chain` | 95 |

The drug-safety CSV contains a quoted field with an embedded line break. Count parsed CSV records, not text-editor lines. The SQL loader specifies CSV quoting and the validation query must still return 1,600 rows. If your MySQL version or local permissions cannot load it faithfully, stop and explain the SQL limitation; do not change the analytical CSV to force a count.

## Project-specific evidence to quote

These are **2026-09-26 pinned-replay expectations only**. The source and calculation code within each linked notebook, not this table, defines the analysis. A fresh publisher response must be judged on its own date and checks.

| Project and notebook | Expected cleaned rows | Principal saved calculation to inspect | Packaged Tableau checkpoint |
|---|---:|---|---|
| [Consumer Complaints](projects/consumer_complaints/notebooks/consumer_complaints_analysis.ipynb) | 6,558 complaint IDs | `analysis/response_queue_intervals.csv`: known-response rates, Wilson intervals, and adjacent-month review signals. | `Executive Dashboard`; full-cohort timely-response rate 98.80%. |
| [Bank Financial Health](projects/sec_financial_health/notebooks/sec_financial_health_analysis.ipynb) | 1,935 bank-quarter rows | `analysis/deposit_outflow_scenario.csv` and `analysis/threshold_sensitivity.csv`: screening scenarios, not default probabilities. | `Bank monitor — overview`; latest quarter 159 banks, 148 scored, 2 at the default review threshold. |
| [Hospital Readmissions](projects/hospital_readmissions/notebooks/hospital_readmissions_analysis.ipynb) | 18,330 facility-measure rows | `analysis/observed_rate_uncertainty.csv`: uncertainty and peer comparison. | `Readmissions — evidence review`; 8,022 scored records, 232 lower-bound signals. |
| [Drug Safety](projects/drug_safety/notebooks/drug_safety_analysis.ipynb) | 1,600 package records | `analysis/concentration_analysis.csv`: listing-level concentration, not patient harm. | `Drug shortages — status and therapy`; 1,152 Current records. |
| [Electricity Affordability](projects/electricity_affordability/notebooks/electricity_affordability_analysis.ipynb) | 275 state-period rows | `analysis/persistence_sensitivity.csv` and `analysis/monthly_pressure_signals.csv`. | `Electricity — commercial growth`; verify the July 2026 endpoint/filter. |
| [Power Plant Emissions](projects/power_plant_emissions/notebooks/power_plant_emissions_analysis.ipynb) | 12,612 plant rows | `analysis/peer_scenarios.csv` and `analysis/abatement_pareto.csv`: hypothetical opportunity. | `Emissions — opportunity screen`; 3,233 estimable scenarios. |
| [Semiconductor Supply Chain](projects/semiconductor_supply_chain/notebooks/semiconductor_supply_chain_analysis.ipynb) | 95 series-period rows | `analysis/divergence_analysis.csv`: mixed economic indicators and lag-screen limits. | `Semiconductors — economic pulse`; verify the distinct series dates. |

## Tableau: reproduce and explain the display

The `.twbx` files are in each project's `tableau/` folder. They are packaged, dated **views of the pinned extract**, not live feeds. Tableau Public or Tableau Desktop is only needed for the dashboard part; the notebook, CSVs, and quality reports remain readable without it.

1. Finish Source through Check in the notebook. After Save, compare the new `tableau_extract.csv` with the supplied pinned extract, starting with rows, fields, and the source date.
2. Open the project's `.twbx` in Tableau. On **Data Source**, confirm that the embedded data is the pinned extract and that its fields/grain agree with the notebook's clean preview. Do not treat the packaged workbook as proof of a new publisher download.
3. Open the named dashboard in the table above. Clear or describe filters, compare its full-cohort checkpoint with the project README, and trace one mark back to a source field, transformation, calculation, and saved row. The other workbook sheets and dashboards provide the visual specification if you need to rebuild the display manually in a new Tableau workbook.
4. For a genuinely new publisher response, connect a new Tableau workbook to **that run's** `tableau_extract.csv` or explicitly replace the data source in a copy of the packaged workbook. Recheck field types, calculated fields, filters, captions, dashboard totals, and interpretation. Save the new workbook separately; do not overwrite or relabel the pinned `.twbx` as current.

If Tableau is unavailable, say so honestly and demonstrate the equivalent `Show` table, extract, source manifest, and quality report. Do not claim a dashboard was visually tested when only its package structure was checked.

## A short interview demonstration

Point to the publisher and pinned response, run Import and show the digest/date, explain one cleaning rule and the record grain, show one formula and its denominator, run Check, identify the saved evidence, and (when Workbench is available) run the four SQL files in order and reconcile row/key counts. Open the corresponding Tableau view or notebook table, then finish with a cautious decision and one limitation. For example: “The dashboard shows a review signal for this dated response. I can trace it to the saved rows and checks; I would investigate it, not claim it proves the cause.”

If any stage fails, stop there. A reproducible interview project is one whose limits and failed checks are visible, not one that hides them to preserve a preferred number.
