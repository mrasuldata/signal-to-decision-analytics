# MySQL handoff: Consumer Complaints

The notebook remains the calculation source of truth. These SQL files create and populate a MySQL 8 mirror of its checked `tableau_extract.csv` so an analyst can inspect the saved rows in Workbench. Run this after the notebook's **Check** and **Save** stages and before **Show**. The SQL does not fetch publisher data, clean it, or replace the notebook's formulas.

1. Open MySQL Workbench and connect to a local MySQL 8 server. Run `SELECT @@secure_file_priv;`. If it returns `NULL`, server-side file import is disabled; stop rather than changing server security settings for this exercise. The account also needs `FILE` privilege.
2. Copy the **current run's** `data/manual_rebuild/<run-date>/tableau_extract.csv` into the returned server upload folder. Rename only that copy to `01_consumer_complaints.csv`. Leave the repository's checked CSV unchanged. If a same-day run uses a digest-suffixed folder, choose that exact folder.
3. Open `create_table.sql` in a text editor. Copy its contents into a Workbench SQL tab and execute. Confirm that `portfolio7.consumer_complaints` appears under Schemas. This schema is separate from any personal database.
4. Make a temporary copy of `load_extract.sql` outside the repository. Replace `__MYSQL_SECURE_FILE_PRIV__` with the folder returned in step 1, using forward slashes. Copy and execute the temporary SQL in Workbench. The script replaces **only** this project's SQL table, then loads the CSV. Do not commit the edited copy or any credential.
5. Run `check_load.sql`. For the pinned 2026-09-26 response, expect **6,558 loaded rows** and **6,558 distinct source keys**, with zero missing key values. Compare the other displayed values with the current run's `quality_report.json` and `tableau_extract.csv`; a fresh publisher response can legitimately differ.
6. Run `review_queries.sql` to inspect the stored analysis fields. The consumer-complaints project includes the response-queue SQL cross-check. The other projects show a small row preview; their original calculations remain in the notebook.

If any SQL count, key, date, or warning differs unexpectedly, stop before presenting the database as verified. A successful `LOAD DATA` message alone is insufficient. The CSV uses quoted fields; the drug-safety extract includes one quoted field with an embedded line break, so count logical CSV records rather than text-editor lines.

The committed SQL contains no computer-specific path. MySQL's server-side `LOAD DATA INFILE` needs the `secure_file_priv` location and `FILE` privilege; do not enable `LOCAL INFILE` as a workaround. If this access is unavailable, the notebook and Tableau path still reproduce the analysis; state that the optional MySQL mirror was not executed.
