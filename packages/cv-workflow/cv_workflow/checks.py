"""Automated checks on a rendered revision PDF, bound to the bytes they examined."""
from datetime import date
import re

from .workspace import sha256_file, utc_now

# A certificate expiring within this many days of the render date is flagged: our
# judgement of the time needed to book a renewal before a contract, not a sourced rule.
EXPIRY_WARNING_DAYS = 180
MONTHS = {m: i + 1 for i, m in enumerate(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])}
# The date format the records use ("14 Jul 2029"); anything else is left unchecked and counted.
EXPIRY = re.compile(r'^\s*(\d{1,2}) ([A-Z][a-z]{2}) (\d{4})\s*$')


def check_certificates(record, today=None):
    """Warn about certificates that have expired or expire soon, read from the record the revision rendered.

    Warnings only (owner's decision, 2026-09-25): they never fail the checks or block
    approval; the owner weighs them when he approves. Both certificate shapes the
    schema allows are read: [title, scope, issued, expires] and {title, ..., review}.
    """
    today = today or date.today()
    warnings, checked, unchecked = [], 0, 0
    certificates = record.get('certificates') if isinstance(record, dict) else None
    # Without a schema (a Framework-only one-off) the key may hold anything; only a list is read.
    for item in certificates if isinstance(certificates, list) else []:
        if isinstance(item, list) and len(item) == 4:
            title, expiry = item[0], item[3]
        elif isinstance(item, dict):
            title, expiry = item.get('title'), item.get('review')
        else:
            unchecked += 1
            continue
        match = EXPIRY.match(expiry) if isinstance(expiry, str) else None
        try:
            expires = date(int(match[3]), MONTHS[match[2]], int(match[1])) if match else None
        except (KeyError, ValueError):  # "31 Feb 2029", "14 Jly 2029": not a date, so not checked
            expires = None
        if expires is None:
            unchecked += 1
            continue
        checked += 1
        days = (expires - today).days
        count = lambda n: f'{n} day' if n == 1 else f'{n} days'
        if days < 0:
            warnings.append(f'Certificate "{title}" EXPIRED on {expiry.strip()} ({count(-days)} before the render date). '
                            'Renew and update the date, remove the row, or replace the date with text such as "Renewal booked".')
        elif days <= EXPIRY_WARNING_DAYS:
            warnings.append(f'Certificate "{title}" expires on {expiry.strip()}, in {count(days)} '
                            f'(within {EXPIRY_WARNING_DAYS}). Check the candidate has booked the renewal.')
    return {'reference_date': today.isoformat(), 'window_days': EXPIRY_WARNING_DAYS,
            'date_checked': checked, 'not_date_checked': unchecked, 'warnings': warnings}


def certificate_summary(checks):
    """The certificate block of a checks.json as (counts, warnings); (None, []) when absent or malformed.

    Revisions rendered before the check have no block; a hand-edited block of the wrong
    shape is ignored rather than crashing `status` (a wrong JSON shape is never a traceback).
    """
    block = checks.get('certificates') if isinstance(checks, dict) else None
    if not isinstance(block, dict):
        return None, []
    warnings = block.get('warnings')
    if not (isinstance(warnings, list) and all(isinstance(w, str) for w in warnings)):
        return None, []
    counts = {key: block.get(key) for key in ('reference_date', 'date_checked', 'not_date_checked')}
    return counts, warnings


def check_pdf(pdf, pages):
    """Page count, no empty page, all fonts embedded, no text outside the page.

    The same sanity rules as tests/verify.py, without the test suite's frozen
    manifest: a candidate revision is checked on its own, never against a reference.
    """
    import pymupdf as fitz  # Only the render path needs it; approve and export do not.
    errors = []
    with fitz.open(pdf) as doc:
        count = len(doc)
        if count != pages:
            errors.append(f'Expected {pages} pages, got {count}')
        for i, page in enumerate(doc):
            if not page.get_text().strip():
                errors.append(f'Empty page {i + 1}')
            for x0, y0, x1, y1, *word in page.get_text('words'):
                if x0 < 0 or y0 < 0 or x1 > page.rect.width or y1 > page.rect.height:
                    errors.append(f'Text out of page bounds on page {i + 1}: {word[0]}')
            if not all(doc.extract_font(f[0])[3] for f in page.get_fonts()):
                errors.append(f'Unembedded font on page {i + 1}')
    return {
        'pdf_sha256': sha256_file(pdf),
        'checked_at': utc_now(),
        'expected_pages': pages,
        'pages': count,
        'errors': errors,
        'passed': not errors,
    }
