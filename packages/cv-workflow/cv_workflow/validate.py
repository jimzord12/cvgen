"""Check a candidate record against the JSON Schema of the template or domain its entry point imports."""
import json
import re

from .workspace import ENGINE, WorkflowError, repo_relative

# /packages/cv-engine/domains/<domain>/templates/<template>/... inside an #import path.
DOMAIN = re.compile(r'domains/([\w-]+)(?:/templates/([\w-]+))?')
MAX_REPORTED = 10


def schema_for(imports):
    """The most specific contract the entry point uses: the template's input schema, else the domain's
    candidate schema, else None (an entry that imports only lib.typ names no domain or template)."""
    found = []
    for path in imports:
        match = DOMAIN.search(path)
        if match:
            domain, template = match.groups()
            candidates = [ENGINE / 'domains' / domain / 'templates' / template / 'schema' / f'{template}-input.schema.json'] if template else []
            candidates.append(ENGINE / 'domains' / domain / 'schema' / 'candidate.schema.json')
            found.append(next((c for c in candidates if c.is_file()), None))
    found = [f for f in found if f]
    # A template schema is stricter than its domain's and includes the template's `copy` key.
    return max(found, key=lambda f: 'templates' in f.parts, default=None)


def validate_record(record, imports):
    """Refuse a record that breaks its contract: unknown or misspelt keys, wrong types, missing fields.

    Returns the schema path used (repository-relative), or None when the entry names no domain.
    """
    schema_path = schema_for(imports)
    if schema_path is None:
        return None
    try:
        from jsonschema import Draft202012Validator
    except ImportError:
        raise WorkflowError('the candidate check needs jsonschema: pip install jsonschema')
    schema = json.loads(schema_path.read_text(encoding='utf-8'))
    errors = sorted(Draft202012Validator(schema).iter_errors(record), key=lambda e: [str(p) for p in e.absolute_path])
    if errors:
        lines = [f'  {"/".join(str(p) for p in e.absolute_path) or "(top level)"}: {e.message}' for e in errors[:MAX_REPORTED]]
        if len(errors) > MAX_REPORTED:
            lines.append(f'  ... and {len(errors) - MAX_REPORTED} more')
        raise WorkflowError(f'candidate.json does not match {repo_relative(schema_path)}:\n' + '\n'.join(lines))
    return repo_relative(schema_path)
