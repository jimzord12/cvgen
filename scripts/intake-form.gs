/**
 * CVgen intake form: builds a Google Form, and a Google Sheet that
 * collects its answers, from the FORM block below.
 *
 * How the owner uses it (docs/guides/client-workflow.md, section 2):
 *   1. script.google.com -> New project -> replace everything with this
 *      file (Claude writes a filled copy per client, in the Envelope).
 *   2. Run createIntakeForm. The first run asks for permission; Google
 *      warns "Google hasn't verified this app": Advanced -> Go to project.
 *   3. The Execution log under the code prints three links: the answer
 *      link for the client, the form's edit link and the Sheet.
 * Each run makes a new form and a new Sheet, so run it once per client.
 *
 * The FORM block here is an example with generic questions. A per-client
 * copy replaces only FORM; the functions stay as they are.
 */

const FORM = {
  // What the client sees at the top of the form.
  title: 'Βιογραφικό: λίγες ερωτήσεις',
  description:
    'Απάντησε όπως σε βολεύει. Πρόχειρα είναι μια χαρά. ' +
    'Μπορείς να αλλάξεις τις απαντήσεις σου και μετά την αποστολή.',
  confirmation: 'Ευχαριστούμε! Τα λέμε σύντομα.',
  // The Sheet's name in the owner's Drive.
  sheetTitle: 'client-yyyy-mm-nn: απαντήσεις',
  // Item kinds: consent (required tick box), section (a heading),
  // short (one line), long (a paragraph). help is optional.
  items: [
    {
      consent: 'Συγκατάθεση',
      agree: 'Συμφωνώ',
      help:
        'Για το βιογραφικό σου χρησιμοποιούμε εργαλεία AI και έρευνα στο ' +
        'διαδίκτυο. Τα στοιχεία σου μένουν στα ιδιωτικά μας αρχεία, δεν ' +
        'δημοσιεύονται ποτέ και σβήνονται 12 μήνες μετά την παράδοση, ' +
        'εκτός αν μας ζητήσεις να τα κρατήσουμε.',
    },
    { section: 'Ο στόχος' },
    { long: 'Για ποια θέση κάνεις αίτηση και σε ποιο επίπεδο;' },
    { short: 'Σε ποια χώρα ή χώρες;' },
  ],
};

function createIntakeForm() {
  FORM.items.forEach(checkItem_);

  const form = FormApp.create(FORM.title)
    .setDescription(FORM.description)
    .setConfirmationMessage(FORM.confirmation)
    .setAllowResponseEdits(true);
  FORM.items.forEach(function (item) {
    addItem_(form, item);
  });

  const sheet = SpreadsheetApp.create(FORM.sheetTitle);
  form.setDestination(FormApp.DestinationType.SPREADSHEET, sheet.getId());

  // Forms made by a script after 30 June 2026 start unpublished.
  form.setPublished(true);
  form.setAcceptingResponses(true);

  Logger.log('Send this link to the client: ' + form.getPublishedUrl());
  Logger.log('Edit the form (you only): ' + form.getEditUrl());
  Logger.log('Answers Sheet (you only): ' + sheet.getUrl());
}

// Fails before anything is created, so a typo never leaves half a form.
function checkItem_(item) {
  const kinds = ['consent', 'section', 'short', 'long'].filter(function (k) {
    return typeof item[k] === 'string' && item[k].length > 0;
  });
  if (kinds.length !== 1) {
    throw new Error('Each item needs exactly one of consent, section, short, long: ' + JSON.stringify(item));
  }
  if (kinds[0] === 'consent' && !item.agree) {
    throw new Error('A consent item needs agree: ' + JSON.stringify(item));
  }
}

function addItem_(form, item) {
  const help = item.help || '';
  if (item.consent) {
    form.addCheckboxItem()
      .setTitle(item.consent)
      .setHelpText(help)
      .setChoiceValues([item.agree])
      .setRequired(true);
  } else if (item.section) {
    form.addSectionHeaderItem().setTitle(item.section).setHelpText(help);
  } else if (item.short) {
    form.addTextItem().setTitle(item.short).setHelpText(help);
  } else {
    form.addParagraphTextItem().setTitle(item.long).setHelpText(help);
  }
}
