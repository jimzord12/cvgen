"""Automated checks on a rendered revision PDF, bound to the bytes they examined."""
from .workspace import sha256_file, utc_now


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
