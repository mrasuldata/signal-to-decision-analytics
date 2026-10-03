"""Offline regression checks; these fixtures are not live MySQL exports."""
import ast
import csv
from contextlib import contextmanager
from datetime import datetime, UTC
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
import shutil
from uuid import uuid4

PORTFOLIO = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('checker', PORTFOLIO / 'scripts/verify_mysql_export.py')
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


@contextmanager
def scratch_directory():
    # Inherit the platform's normal directory ACLs rather than tightening them.
    parent = Path(tempfile.gettempdir()).resolve()
    folder = parent / ('portfolio-test-' + uuid4().hex)
    folder.mkdir(exist_ok=False)
    try:
        yield folder
    finally:
        resolved = folder.resolve()
        if resolved.parent != parent or not resolved.name.startswith('portfolio-test-'):
            raise RuntimeError('Refusing to remove an unexpected test directory')
        shutil.rmtree(resolved)


class ReproducibilityTests(unittest.TestCase):
    def test_preserve_existing_and_partial_runs(self):
        for notebook in PORTFOLIO.glob('projects/*/notebooks/*.ipynb'):
            with self.subTest(project=notebook.parent.parent.name), scratch_directory() as tmp:
                nb = json.loads(notebook.read_text(encoding='utf-8'))
                code = next(''.join(c['source']) for c in nb['cells'] if c.get('id') == 'save-code')
                tree = ast.parse(code)
                # Exercise the real Save path-selection code, stopping before table writes.
                nodes = []
                for node in tree.body:
                    if isinstance(node, ast.Expr) and isinstance(node.value, ast.Call) and ast.unparse(node.value.func) == 'clean.to_csv':
                        break
                    nodes.append(node)
                setup = compile(ast.fix_missing_locations(ast.Module(body=nodes, type_ignores=[])), 'save-path', 'exec')
                project = Path(tmp)
                baseline = project / 'data/manual_rebuild/2026-09-26'
                baseline.mkdir(parents=True)
                sentinel = baseline / 'partial-evidence.txt'
                sentinel.write_text('keep this unchanged', encoding='utf-8')
                ns = {'PROJECT': project, 'SNAPSHOT_DATE': '2026-09-26', 'report': {'passed': True, 'rows': 1},
                      'clean': [1], 'SLUG': 'test', 'FETCH_LOG': [{'sha256': 'abc'}], 'datetime': datetime, 'UTC': UTC}
                exec(setup, ns)
                first = ns['OUTPUT_DIR']
                exec(setup, ns)
                self.assertNotEqual(first, baseline)
                self.assertNotEqual(ns['OUTPUT_DIR'], first)
                self.assertEqual(sentinel.read_text(encoding='utf-8'), 'keep this unchanged')
                self.assertEqual(list(baseline.iterdir()), [sentinel])
                ns['report']['passed'] = False
                with self.assertRaises(AssertionError):
                    exec(setup, ns)

    def test_all_projects_compare_every_column(self):
        for project in sorted((PORTFOLIO / 'projects').iterdir()):
            if not (project / 'sql/create_table.sql').is_file():
                continue
            with self.subTest(project=project.name), scratch_directory() as tmp:
                kinds, keys = checker.schema(project)
                source = project / 'data/manual_rebuild/2026-09-26/tableau_extract.csv'
                with source.open(encoding='utf-8-sig', newline='') as handle:
                    rows = list(csv.DictReader(handle))
                records = []
                for row in rows:
                    item = {}
                    for col, kind in kinds.items():
                        raw = row[col]
                        if raw == '':
                            item[col] = None
                        elif kind == 'DOUBLE':
                            item[col] = float(raw)
                        elif kind in {'BIGINT', 'TINYINT'}:
                            item[col] = int(raw)
                        elif kind == 'DATETIME':
                            item[col] = datetime.fromisoformat(raw).isoformat(sep=' ')
                        else:
                            item[col] = raw
                    records.append(item)
                export = Path(tmp) / 'export.csv'

                def write(items):
                    with export.open('w', encoding='utf-8', newline='') as handle:
                        writer = csv.writer(handle)
                        writer.writerow(['row_json'])
                        writer.writerows([[json.dumps(row)] for row in items])

                write(list(reversed(records)))
                self.assertEqual(checker.compare(project, '2026-09-26', export), (len(records), len(kinds)))
                for bad in [records[:-1], records[:-1] + [records[0]]]:
                    write(bad)
                    with self.assertRaises(ValueError):
                        checker.compare(project, '2026-09-26', export)
                different_id = dict(records[0])
                text_key = next(c for c in keys if kinds[c] == 'VARCHAR')
                different_id[text_key] = 'not-the-original-id'
                write([different_id, *records[1:]])
                with self.assertRaises(ValueError):
                    checker.compare(project, '2026-09-26', export)
                changed = dict(records[0])
                col = next(c for c in kinds if c not in keys and kinds[c] == 'DOUBLE' and changed[c] is not None)
                changed[col] += 123
                write([changed, *records[1:]])
                with self.assertRaises(ValueError):
                    checker.compare(project, '2026-09-26', export)
                del changed[col]
                write([changed, *records[1:]])
                with self.assertRaises(ValueError):
                    checker.compare(project, '2026-09-26', export)


if __name__ == '__main__':
    unittest.main()
