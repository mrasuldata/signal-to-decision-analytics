# Seven-project, source-replayable analytics portfolio

This release contains seven independently replayable projects. Every included result was rebuilt from a publisher response acquired on **2026-09-26**. Earlier processed results and dashboard images are not included because their original publisher responses were unavailable for exact replay. The Tableau dashboards preserve the earlier visual designs but use the pinned 2026-09-26 extracts; snapshot-specific captions and lookup values were reconciled where the source changed.

## Run it after ZIP extraction or Git download

The replay was tested with Python 3.13, pandas 3.0.5, NumPy 2.5.1, SciPy 1.18.1, Requests 2.34.2, IPython 9.16.1, and openpyxl 3.1.5. In your own Python environment, install those versions and JupyterLab, then open a terminal at the extracted portfolio root:

```sh
python -m pip install jupyterlab "pandas==3.0.5" "numpy==2.5.1" "scipy==1.18.1" "requests==2.34.2" "ipython==9.16.1" "openpyxl==3.1.5"
jupyter lab
```

Open the project-named analysis notebook in that project's `notebooks/` folder. Run **one stage at a time** and inspect its visible output and check before continuing. Do not add your local environment or notebook checkpoints to the package.

For a complete interview demonstration from a GitHub download or ZIP, follow the [step-by-step lineage walkthrough](LINEAGE_WALKTHROUGH.md). It maps every Source → Decide instruction to the corresponding notebook code cell, expected visible output, stop/check gate, saved evidence, manual MySQL handoff, and Tableau checkpoint.

The stage sequence is **Source → Import → Transform and clean → Calculate → Check → Save → Show → Decide**. All eight stages were replayed for the included 2026-09-26 response. Each `Decide` cell contains a bounded, source-dated interpretation and limitation; revise both if you acquire a fresh response. A successful saved quality report is a prerequisite, not a substitute for judgment.

`USE_PINNED_RAW = True` (the notebook default) replays the exact included publisher response without an Internet connection. Set it to `False` only when intentionally acquiring a **fresh** response. A fresh response is preserved with retrieval metadata and SHA-256; its rows and calculations can change. Save keeps a same-day response with a different source digest in a separate, digest-suffixed folder rather than overwriting the verified run. It refuses to overwrite a conflicting partial folder. No fresh response is claimed to recreate the unsupplied older portfolio snapshot.

## Tableau dashboards

Each project has a packaged Tableau workbook (`tableau/*.twbx`) with the dated extract embedded. Open it in Tableau Public or Tableau Desktop after downloading or extracting the portfolio; no machine-specific path is needed. The workbook is a saved view of the pinned source, not an automatic pipeline. To reproduce the data behind it, run the project's manual notebook from Source through Check, compare the saved row count and key figures, then inspect the workbook's Data Source and dashboard tabs. For a new publisher response, rerun the notebook and consciously refresh and reconcile the workbook before presenting it. The included workbook must not be described as a live current-data dashboard.

| Project | Publisher | Verified cleaned rows | Supported display |
|---|---|---:|---|
| [Consumer Complaints](projects/consumer_complaints/README.md) | CFPB complaint API | 6,558 | Notebook interval queue; Tableau complaint review |
| [Bank Financial Health](projects/sec_financial_health/README.md) | FDIC BankFind | 1,935 | Notebook deposit scenario; Tableau bank monitor |
| [Hospital Readmissions](projects/hospital_readmissions/README.md) | CMS | 18,330 | Notebook uncertainty table; Tableau readmission review |
| [Drug Safety](projects/drug_safety/README.md) | FDA openFDA | 1,600 | Notebook concentration table; Tableau shortage review |
| [Electricity Affordability](projects/electricity_affordability/README.md) | EIA | 275 | Notebook pressure signals; Tableau electricity review |
| [Power Plant Emissions](projects/power_plant_emissions/README.md) | EPA eGRID | 12,612 | Notebook abatement table; Tableau emissions screen |
| [Semiconductor Supply Chain](projects/semiconductor_supply_chain/README.md) | BLS | 95 | Notebook divergence table; Tableau economic pulse |

Project folders, notebooks, and Tableau workbooks use descriptive names without numeric prefixes. Older project IDs remain in SQL table names, staged CSV names, and saved evidence for traceability; they are not folder paths. Saved notebook figures come from the verified pinned run; path text in those outputs is displayed relative to the portfolio root for portability. Re-running the stages regenerates that display.

Each project includes the exact pinned response bytes and metadata under `data/raw/`, a tested dated extract and analytical tables under `data/manual_rebuild/2026-09-26/`, and a self-contained manual notebook. The `.body` files in `publisher_responses/` are preserved publisher payloads, not compiled caches. Source URLs, request parameters, SHA-256 values, quality results, and table counts are visible in the notebook and saved evidence. All local references are project-relative; no machine-specific absolute path, credential, configuration file, launcher, or background pipeline is required.

The root `.gitignore` excludes only local environments, editor files, and caches. It deliberately keeps the publisher responses, saved results, notebooks, documentation, and Tableau workbooks eligible for GitHub. `.gitattributes` prevents line-ending conversion of the pinned raw responses and verified results, so their checksums survive a Windows checkout. A `config` folder is not needed for this manual, project-relative workflow.

The `Show` stage displays the reproducible analysis in the notebook, and `tableau_extract.csv` is the matching dashboard input. The packaged Tableau views are additional displays; they do not replace the Source → Decide checks or the interpretation limits in each notebook.

## Manual SQL check

Each project now has `sql/create_table.sql`, `sql/load_extract.sql`, `sql/check_load.sql`, `sql/review_queries.sql`, and `sql/README.md`, following the CDC reference's visible Workbench sequence. Run these **after** the notebook's Check and Save stages. The schema and population files load a separate MySQL mirror of the checked `tableau_extract.csv`; they do not alter the publisher response, notebook calculations, saved metrics, or Tableau workbook. MySQL is needed only if you choose to demonstrate that database handoff. See the [manual MySQL steps](LINEAGE_WALKTHROUGH.md#manual-mysql-handoff-after-save) before running SQL. A fresh response must be loaded and checked against its own quality report, never compared blindly with the pinned 2026-09-26 figures.

See [source reuse](SOURCE_REUSE.md) for the seven-source permission screen. Attribution is provided for provenance even where not required for reuse.
