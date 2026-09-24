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


def schema_for(imports, engine=ENGINE):
    """The most specific contract the entry point uses: a template's input schema; else Flagship's when
    lib.typ is imported and every domain named is marine (lib.typ's flat exports are marine and Flagship);
    else a domain's candidate schema; else None."""
    found, domains = [], set()
    for path in imports:
        match = DOMAIN.search(path)
        if match:
            domain, template = match.groups()
            domains.add(domain)
            candidates = [engine / 'domains' / domain / 'templates' / template / 'schema' / f'{template}-input.schema.json'] if template else []
            candidates.append(engine / 'domains' / domain / 'schema' / 'candidate.schema.json')
            found.append(next((c for c in candidates if c.is_file()), None))
    found = [f for f in found if f]
    # Judge by the path inside the engine, never by where the checkout happens to live.
    templates = [f for f in found if 'templates' in f.relative_to(engine).parts]
    if templates:
        # A template schema is stricter than its domain's and includes the template's `copy` key.
        return templates[0]
    if any(LIB.search(path) for path in imports) and domains <= {'marine'}:
        return engine / LIB_SCHEMA.relative_to(ENGINE)
    return found[0] if found else None


def describe(error):
    """One line per problem: the field path and what to change. A oneOf failure is unpacked into the
    reasons of its alternatives: a field's own error is kept, only the "not this alternative at all"
    type mismatch is dropped, so a misspelt key or a wrong value inside a certificate is named."""
    reasons = [e for e in error.context if not (e.validator == 'type' and not e.relative_path)] or [error]
    lines = []
    for e in reasons:
        where = '/'.join(str(p) for p in e.absolute_path) or '(top level)'
        message = 'is null; give a value, or leave the key out if it is optional' if e.validator == 'type' and e.instance is None else e.message
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
