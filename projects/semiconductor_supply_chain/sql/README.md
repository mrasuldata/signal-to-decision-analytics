# MySQL handoff: Semiconductor Supply Chain

The notebook remains the calculation source of truth. These SQL files create and populate a MySQL 8 mirror of its checked `tableau_extract.csv` so an analyst can inspect the saved rows in Workbench. Run this after the notebook's **Check** and **Save** stages and before **Show**. The SQL does not fetch publisher data, clean it, or replace the notebook's formulas.

1. Open MySQL Workbench and connect to a local MySQL 8 server. Run `SELECT @@secure_file_priv;`. If it returns `NULL`, server-side file import is disabled; stop rather than changing server security settings for this exercise. The account also needs `FILE` privilege.
2. Copy the **current run's** `data/manual_rebuild/<run-date>/tableau_extract.csv` into the returned server upload folder. Rename only that copy to `10_semiconductor_supply_chain.csv`. Leave the repository's checked CSV unchanged. If Save printed a suffixed run folder, choose that exact folder.
3. Open `create_table.sql` in a text editor. Copy its contents into a Workbench SQL tab and execute. Confirm that `portfolio7.p10_semiconductor_supply_chain` appears under Schemas. This schema is separate from any personal database.
4. Make a temporary copy of `load_extract.sql` outside the repository. Replace `__MYSQL_SECURE_FILE_PRIV__` with the folder returned in step 1, using forward slashes. Copy and execute the temporary SQL in Workbench. The script replaces **only** this project's SQL table, then loads the CSV. Do not commit the edited copy or any credential.
5. Run `check_load.sql`. For the pinned 2026-09-26 response, expect **95 loaded rows** and **95 distinct source keys**, with zero missing key values. Compare the other displayed values with the current run's `quality_report.json` and `tableau_extract.csv`; a fresh publisher response can legitimately differ.
6. Run `review_queries.sql` to inspect the stored analysis fields. The consumer-complaints project includes the response-queue SQL cross-check. The other projects show a small row preview; their original calculations remain in the notebook.

If any SQL count, key, date, or warning differs unexpectedly, stop before presenting the database as verified. A successful `LOAD DATA` message alone is insufficient. The CSV uses quoted fields; the drug-safety extract includes one quoted field with an embedded line break, so count logical CSV records rather than text-editor lines.

The committed SQL contains no computer-specific path. MySQL's server-side `LOAD DATA INFILE` needs the `secure_file_priv` location and `FILE` privilege; do not enable `LOCAL INFILE` as a workaround. If this access is unavailable, the notebook and Tableau path still reproduce the analysis; state that the optional MySQL mirror was not executed.


## Server upload directory

If the result is a directory, use that existing directory on the **MySQL server**, with permission to copy and read the file. If it is SQL `NULL`, stop: server-side import is disabled. If it is an empty string, no upload directory is designated by this setting; choose an existing server-side staging directory permitted by your database administrator, or skip the optional SQL demonstration. Do not weaken security settings. A server path is not necessarily the folder on the computer running Workbench. Use forward slashes and remove a trailing slash before inserting the directory into the loader; it already adds `/filename.csv`.

Reference: [MySQL secure_file_priv](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_secure_file_priv).

## Compare every stored record, not just the counts

Counts and summary queries are preliminary checks. Two tables can have the same number of distinct IDs but contain different IDs or values.

1. Complete the load and warning checks above. In Workbench select **Don't Limit** for the result-row limit, then run `export_for_comparison.sql`. It is read-only and returns one JSON value per source record; JSON keeps database nulls distinct from the literal text "NULL".
2. Export the entire result grid as UTF-8 **CSV with column names**, not JSON or SQL inserts. Keep the single header `row_json`. Save it next to the portfolio's top-level README as `mysql-export-semiconductor_supply_chain.csv`. This is a local client export, not `SELECT INTO OUTFILE`; it does not require a server output folder.
3. From a terminal in that extracted portfolio folder, run:

```sh
python scripts/verify_mysql_export.py --project semiconductor_supply_chain --run 2026-09-26 --export mysql-export-semiconductor_supply_chain.csv
```

Use `2026-09-26` only when the database was loaded from that supplied saved extract. If it was loaded from a new Save run, replace `--run` with the **exact folder name printed by Save**, including its suffix. The comparison script finds this downloaded portfolio from its own location; no fixed computer path is needed.

4. Expect a `PASS` for matching source keys and **all** stored source columns. The generated `sql_row_id` is intentionally excluded. Text and IDs compare exactly (including leading zeros), dates compare after date parsing, whole numbers compare exactly, and DOUBLE values allow only relative `1e-12` / absolute `1e-12` floating-point tolerance. Empty CSV fields correspond to SQL NULL, as defined by `load_extract.sql`.
5. Stop on a mismatch, missing/duplicate key, truncated export, or missing column. Do not edit the saved source to make the test pass. This checks the supplied export against the chosen CSV; it does not verify which server produced the export, prove the calculations are correct, or test Tableau. No live SQL test is claimed merely because a saved quality report says passed.

The comparison helper is optional, uses Python's standard library, and does not change data or connect to MySQL. The analysis itself still runs entirely in the notebook. Do not commit the export; `.gitignore` covers this filename pattern for untracked files only.
