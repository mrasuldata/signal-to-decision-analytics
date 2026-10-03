"""Compare an optional MySQL JSON-row CSV export with one saved project extract.

Run from the extracted portfolio folder. Uses only Python's standard library.
The export must come from that project's sql/export_for_comparison.sql.
"""
import argparse
import csv
from datetime import datetime
from decimal import Decimal, InvalidOperation
import json
import math
from pathlib import Path
import re


def schema(project):
    text = (project / 'sql/create_table.sql').read_text(encoding='utf-8')
    columns = dict(re.findall(r'^\s+`([^`]+)` (VARCHAR|BIGINT|TINYINT|DOUBLE|DATETIME)\b', text, re.M))
    columns.pop('sql_row_id')
    key_clause = re.search(r'UNIQUE KEY `unique_source_row` \(([^)]+)\)', text)
    if not key_clause:
        raise ValueError('Missing source-key definition in create_table.sql')
    return columns, re.findall(r'`([^`]+)`', key_clause.group(1))


def value(raw, kind, *, source=False):
    # The loader intentionally converts empty source fields to SQL NULL.
    if raw is None or (source and raw == ''):
        return None
    if kind == 'VARCHAR':
        if not isinstance(raw, str):
            raise ValueError('Expected a text value (IDs must retain leading zeros)')
        return raw
    if kind == 'DATETIME':
        return datetime.fromisoformat(str(raw))
    if kind in {'BIGINT', 'TINYINT'}:
        number = Decimal(str(raw))
        if not number.is_finite() or number != number.to_integral_value():
            raise ValueError('Expected a finite whole number')
        return int(number)
    number = float(raw)
    if not math.isfinite(number):
        raise ValueError('Non-finite numeric value')
    return number


def compare(project, run, export):
    columns, keys = schema(project)
    saved = project / 'data/manual_rebuild' / run
    if Path(run).name != run or run in {'.', '..'}:
        raise ValueError('--run must be one dated folder name, not a path')
    quality = json.loads((saved / 'quality_report.json').read_text(encoding='utf-8'))
    if quality.get('passed') is not True:
        raise ValueError('The saved quality report did not pass')
    with (saved / 'tableau_extract.csv').open(encoding='utf-8-sig', newline='') as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames != list(columns):
            raise ValueError('Saved CSV columns differ from the SQL schema/order')
        source_rows = list(reader)
    with export.open(encoding='utf-8-sig', newline='') as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames != ['row_json']:
            raise ValueError('Export the row_json result as CSV with its column header')
        sql_rows = []
        for row in reader:
            if set(row) != {'row_json'} or row['row_json'] is None:
                raise ValueError('Malformed CSV export record')
            sql_rows.append(json.loads(row['row_json']))
    if len(source_rows) != quality['rows'] or len(sql_rows) != len(source_rows):
        raise ValueError(f'Count mismatch: source={len(source_rows)}, SQL={len(sql_rows)}, report={quality["rows"]}')

    def index(rows, source):
        found = {}
        for row in rows:
            if not isinstance(row, dict) or set(row) != set(columns):
                raise ValueError('Record columns differ from the SQL schema')
            normalized = {c: value(row[c], kind, source=source) for c, kind in columns.items()}
            key = tuple(normalized[c] for c in keys)
            if any(v is None or v == '' for v in key) or key in found:
                raise ValueError(f'Missing or duplicate source key: {key!r}')
            found[key] = normalized
        return found

    expected, actual = index(source_rows, True), index(sql_rows, False)
    if expected.keys() != actual.keys():
        raise ValueError('Source IDs differ, even if the counts match')
    for key, row in expected.items():
        for column, left in row.items():
            right = actual[key][column]
            equal = left == right
            if columns[column] == 'DOUBLE' and left is not None and right is not None:
                equal = math.isclose(left, right, rel_tol=1e-12, abs_tol=1e-12)
            if not equal:
                raise ValueError(f'Value mismatch at source key {key!r}, column {column}: CSV={left!r}, SQL={right!r}')
    return len(expected), len(columns)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', required=True, help='Descriptive project folder name')
    parser.add_argument('--run', default='2026-09-26', help='Exact saved run folder name')
    parser.add_argument('--export', required=True, type=Path, help='Workbench CSV export of row_json')
    args = parser.parse_args()
    portfolio = Path(__file__).resolve().parents[1]
    project = portfolio / 'projects' / args.project
    if Path(args.project).name != args.project or not (project / 'sql/create_table.sql').is_file():
        parser.error('Choose a project folder included in this portfolio')
    try:
        rows, columns = compare(project, args.run, args.export)
    except (ValueError, OSError, KeyError, TypeError, OverflowError, InvalidOperation, csv.Error) as error:
        parser.exit(1, f'FAIL: {error}\n')
    print(f'PASS: {rows} source keys and all {columns} stored columns match the selected saved CSV.')
    print('DOUBLE tolerance: relative 1e-12, absolute 1e-12. Other values compare exactly after declared type conversion.')
    print('This verifies the supplied export, not the database connection, calculation validity, or Tableau display.')


if __name__ == '__main__':
    main()
