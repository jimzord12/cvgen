/**
 * CVgen intake form: builds a Google Form, and a Google Sheet that
 * collects its answers, from the FORM block below.
 *
 * How the owner uses it (docs/guides/client-workflow.md, section 2):
 *   1. script.google.com -> New project -> replace everything with this
 *      file (Claude writes a filled copy per form, intake/form-NN.gs in
 *      the Envelope). Rename "Untitled project" to the client's Alias.
 *   2. Run createIntakeForm. The first run asks for permission; Google
 *      warns "Google hasn't verified this app": Advanced -> Go to project.
 *   3. The Execution log under the code prints three links: the answer
 *      link for the client, the form's edit link and the Sheet. Paste
 *      them, with the project's own link, back to Claude for the
 *      Envelope's README.md: they are what gets deleted at the delete-by
 *      date.
 *   4. Open the edit link and apply the house theme (the palette icon);
 *      the steps are in docs/guides/client-workflow.md, section 2.
 * Each run makes a new form and a new Sheet, so run it once per form.
 *
 * The FORM block here is an example. A per-client copy replaces only
 * FORM; the functions stay as they are.
 *
 * Item kinds (exactly one per item; any item may add help, and any
 * question may add required: true):
 *   page      a new page; id lets a choice jump to it
 *   section   a heading inside a page
 *   consent   a required tick box; agree is its label
 *   short     one line; validate: 'email' | 'url' | 'number'
 *   long      a paragraph
 *   choice    one of options (radio); other: true adds "Other";
 *             goTo maps an option to a later page id, or 'submit'. A
 *             jump only skips ahead; after it, pages follow in order.
 *             A choice with goTo must be required.
 *   checks    any of options (tick boxes); other: true adds "Other"
 *   dropdown  one of options, in a drop-down list
 *   scale     a number from `from` (0 or 1) to `to` (3-10), with low
 *             and high labels
 *   grid      one answer per row: rows and columns
 *   date      a calendar date
 */

const FORM = {
  // What the client sees at the top of the form, under the header image.
  title: 'Το βιογραφικό σας: πρώτα στοιχεία',
  description:
    'Με αυτές τις ερωτήσεις ξεκινάμε το βιογραφικό σας. ' +
    'Θα σας πάρει περίπου 10 λεπτά. Μια πρόχειρη απάντηση αρκεί.\n\n' +
    'Μετά την αποστολή θα δείτε έναν σύνδεσμο για να αλλάξετε τις ' +
    'απαντήσεις σας. Κρατήστε τον.',
  confirmation: 'Ευχαριστούμε! Θα επικοινωνήσουμε σύντομα μαζί σας.',
  // The Sheet's name in the owner's Drive.
  sheetTitle: 'client-yyyy-mm-nn: απαντήσεις',
  items: [
    {
      consent: 'Συγκατάθεση',
      agree: 'Συμφωνώ',
      help:
        'Για το βιογραφικό σας χρησιμοποιούμε εργαλεία AI και έρευνα στο ' +
        'διαδίκτυο. Τα στοιχεία σας μένουν στα ιδιωτικά μας αρχεία, δεν ' +
        'δημοσιεύονται ποτέ και σβήνονται 12 μήνες μετά την παράδοση, ' +
        'εκτός αν μας ζητήσετε να τα κρατήσουμε.',
    },
    { page: 'Ο στόχος σας' },
    { long: 'Για ποια θέση κάνετε αίτηση;', required: true },
    {
      choice: 'Σε ποιο επίπεδο;',
      options: ['Πρώτη θέση στον χώρο', 'Ίδιο επίπεδο με σήμερα', 'Προαγωγή'],
    },
    { checks: 'Σε ποιες χώρες;', options: ['Ελλάδα', 'Κύπρος', 'Ευρώπη'], other: true },
  ],
};

const KINDS = ['page', 'section', 'consent', 'short', 'long', 'choice', 'checks',
  'dropdown', 'scale', 'grid', 'date'];
const KEYS = KINDS.concat(['id', 'help', 'required', 'agree', 'validate', 'options',
  'other', 'goTo', 'from', 'to', 'low', 'high', 'rows', 'columns']);

function createIntakeForm() {
  checkForm_(FORM);

  const form = FormApp.create(FORM.title)
    .setDescription(FORM.description)
    .setConfirmationMessage(FORM.confirmation)
    .setAllowResponseEdits(true)
    .setProgressBar(true);

  const pages = {};
  const jumps = [];
  FORM.items.forEach(function (item) {
    addItem_(form, item, pages, jumps);
  });
  // A choice may jump to a page that comes after it, so jumps are set last.
  jumps.forEach(function (jump) {
    jump.question.setChoices(jump.item.options.map(function (option) {
      const target = jump.item.goTo[option];
      if (!target) return jump.question.createChoice(option);
      if (target === 'submit') {
        return jump.question.createChoice(option, FormApp.PageNavigationType.SUBMIT);
      }
      return jump.question.createChoice(option, pages[target]);
    }));
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

// A mistake in FORM fails here, before anything is created.
function checkForm_(spec) {
  const pageAt = Object.create(null);
  spec.items.forEach(function (item, index) {
    if (!(item.page && item.id)) return;
    if (item.id in pageAt) throw new Error('Two pages share the id "' + item.id + '"');
    pageAt[item.id] = index;
  });
  spec.items.forEach(function (item, index) {
    const where = ': ' + JSON.stringify(item);
    Object.keys(item).forEach(function (key) {
      if (KEYS.indexOf(key) < 0) throw new Error('Unknown key "' + key + '"' + where);
    });
    const kinds = KINDS.filter(function (k) {
      return typeof item[k] === 'string' && item[k].length > 0;
    });
    if (kinds.length !== 1) throw new Error('Each item needs exactly one of ' + KINDS.join(', ') + where);
    const kind = kinds[0];
    if (kind === 'consent' && !item.agree) throw new Error('A consent item needs agree' + where);
    if (['choice', 'checks', 'dropdown'].indexOf(kind) >= 0 &&
        !(Array.isArray(item.options) && item.options.length >= 2)) {
      throw new Error('A ' + kind + ' item needs at least two options' + where);
    }
    if (kind === 'grid' && !(Array.isArray(item.rows) && item.rows.length > 0 &&
        Array.isArray(item.columns) && item.columns.length >= 2)) {
      throw new Error('A grid item needs rows and at least two columns' + where);
    }
    if (kind === 'scale' && !((item.from === 0 || item.from === 1) && item.to >= 3 && item.to <= 10)) {
      throw new Error('A scale runs from 0 or 1 to 3-10' + where);
    }
    if (item.validate && ['email', 'url', 'number'].indexOf(item.validate) < 0) {
      throw new Error('validate is email, url or number' + where);
    }
    if (item.goTo) {
      if (kind !== 'choice') throw new Error('Only a choice item can have goTo' + where);
      if (item.other) throw new Error('A choice with goTo cannot also have other' + where);
      if (item.required !== true) throw new Error('A choice with goTo must be required' + where);
      Object.keys(item.goTo).forEach(function (option) {
        const target = item.goTo[option];
        if (item.options.indexOf(option) < 0) throw new Error('goTo names an unknown option "' + option + '"' + where);
        if (target === 'submit') return;
        if (!(target in pageAt)) throw new Error('goTo names an unknown page "' + target + '"' + where);
        if (pageAt[target] < index) throw new Error('goTo can only jump ahead, not to "' + target + '"' + where);
      });
    }
  });
}

function addItem_(form, item, pages, jumps) {
  const help = item.help || '';
  const required = item.required === true;
  if (item.page) {
    const page = form.addPageBreakItem().setTitle(item.page).setHelpText(help);
    if (item.id) pages[item.id] = page;
  } else if (item.section) {
    form.addSectionHeaderItem().setTitle(item.section).setHelpText(help);
  } else if (item.consent) {
    form.addCheckboxItem().setTitle(item.consent).setHelpText(help)
      .setChoiceValues([item.agree]).setRequired(true);
  } else if (item.short) {
    const text = form.addTextItem().setTitle(item.short).setHelpText(help).setRequired(required);
    if (item.validate) text.setValidation(textRule_(item.validate));
  } else if (item.long) {
    form.addParagraphTextItem().setTitle(item.long).setHelpText(help).setRequired(required);
  } else if (item.choice) {
    const question = form.addMultipleChoiceItem().setTitle(item.choice).setHelpText(help)
      .setRequired(required);
    if (item.goTo) {
      jumps.push({ question: question, item: item });
    } else {
      question.setChoiceValues(item.options).showOtherOption(item.other === true);
    }
  } else if (item.checks) {
    form.addCheckboxItem().setTitle(item.checks).setHelpText(help).setRequired(required)
      .setChoiceValues(item.options).showOtherOption(item.other === true);
  } else if (item.dropdown) {
    form.addListItem().setTitle(item.dropdown).setHelpText(help).setRequired(required)
      .setChoiceValues(item.options);
  } else if (item.scale) {
    form.addScaleItem().setTitle(item.scale).setHelpText(help).setRequired(required)
      .setBounds(item.from, item.to).setLabels(item.low || '', item.high || '');
  } else if (item.grid) {
    form.addGridItem().setTitle(item.grid).setHelpText(help).setRequired(required)
      .setRows(item.rows).setColumns(item.columns);
  } else {
    form.addDateItem().setTitle(item.date).setHelpText(help).setRequired(required)
      .setIncludesYear(true);
  }
}

function textRule_(kind) {
  const rule = FormApp.createTextValidation();
  if (kind === 'email') {
    rule.requireTextIsEmail().setHelpText('Γράψτε ένα email, π.χ. onoma@gmail.com');
  } else if (kind === 'url') {
    rule.requireTextIsUrl().setHelpText('Γράψτε έναν σύνδεσμο που ξεκινά με https://');
  } else {
    rule.requireNumber().setHelpText('Γράψτε έναν αριθμό');
  }
  return rule.build();
}
