"""Check a candidate record against the JSON Schema of the template or domain its entry point imports."""
import json
import re

from .workspace import ENGINE, WorkflowError, repo_relative

# /packages/cv-engine/domains/<domain>/templates/<template>/... inside an #import path.
DOMAIN = re.compile(r'domains/([\w-]+)(?:/templates/([\w-]+))?')
# lib.typ exports the marine domain and Flagship under flat names (docs/reference/domains-and-roles.md);
# every later domain is exported with a prefix, so an entry importing only lib.typ uses these.
LIB = re.compile(r'(^|/)packages/cv-engine/lib\.typ$')
LIB_SCHEMA = ENGINE / 'domains/marine/templates/flagship/schema/flagship-input.schema.json'
MAX_REPORTED = 10


def schema_for(imports):
    """The most specific contract the entry point uses: a template's input schema, else a domain's
    candidate schema, else Flagship's when only lib.typ is imported, else None."""
    found = []
    for path in imports:
        match = DOMAIN.search(path)
        if match:
            domain, template = match.groups()
            candidates = [ENGINE / 'domains' / domain / 'templates' / template / 'schema' / f'{template}-input.schema.json'] if template else []
            candidates.append(ENGINE / 'domains' / domain / 'schema' / 'candidate.schema.json')
            found.append(next((c for c in candidates if c.is_file()), None))
    found = [f for f in found if f]
    if found:
        # A template schema is stricter than its domain's and includes the template's `copy` key.
        # Judge by the path inside the engine, never by where the checkout happens to live.
        return max(found, key=lambda f: 'templates' in f.relative_to(ENGINE).parts)
    return LIB_SCHEMA if any(LIB.search(path) for path in imports) else None


def describe(error):
    """One line per problem: the field path and what to change. A oneOf failure is unpacked into the
    reasons of its alternatives, so a misspelt key inside a certificate is named, not the whole object."""
    reasons = [e for e in error.context if e.validator != 'type'] or [error]
    lines = []
    for e in reasons:
        where = '/'.join(str(p) for p in e.absolute_path) or '(top level)'
        message = 'is null; leave the key out instead' if e.validator == 'type' and e.instance is None else e.message
        line = f'  {where}: {message}'
        if line not in lines:
            lines.append(line)
    return lines


def validate_record(record, imports):
    """Refuse a record that breaks its contract: unknown or misspelt keys, wrong types, missing fields.

    Returns the schema path used (repository-relative), or None when the entry imports neither lib.typ
    nor a domain, so there is no contract to check against.
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
        lines = [line for e in errors for line in describe(e)]
        extra = len(lines) - MAX_REPORTED
        lines = lines[:MAX_REPORTED] + ([f'  ... and {extra} more'] if extra > 0 else [])
        raise WorkflowError(f'candidate.json does not match {repo_relative(schema_path)}:\n' + '\n'.join(lines))
    return repo_relative(schema_path)
