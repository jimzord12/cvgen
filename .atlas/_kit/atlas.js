/* Atlas kit — renders every atlas page from window.ATLAS (written by atlas.py build).
   Generic: no repository names or facts live here. Works from file:// (no fetch, no network). */
(function () {
  'use strict';
  var A = window.ATLAS;
  if (!A) { document.body.textContent = 'atlas.data.js is missing. Run: python .atlas/_kit/atlas.py build'; return; }

  var site = A.site, pages = A.pages, build = A.build || {};
  var PID = document.body.getAttribute('data-page') || 'index';
  var PAGE = pages.filter(function (p) { return p.id === PID; })[0];
  var byId = {}; pages.forEach(function (p) { byId[p.id] = p; });
  var ROSTER = pages.filter(function (p) { return p.kind === 'roster'; })[0];
  var ACT = site.actors || {};
  var TERMS = site.terms || {};
  var NS = 'http://www.w3.org/2000/svg';

  var KIND_ORDER = ['owner', 'client', 'lead', 'agent', 'external', 'skill', 'tool', 'service'];
  var KIND_LABEL = { owner: 'Owner', client: 'Client', lead: 'Lead agent', agent: 'Subagent', external: 'External model',
    skill: 'Skill', tool: 'Script / tool', service: 'Service' };
  var KIND_BLURB = {
    owner: 'Decides, approves, reviews. Gold always means: this is your move.',
    client: 'The person the work is for. Waits are shown in rose.',
    lead: 'The main agent in the session. Plans, builds, integrates.',
    agent: 'A subagent with its own profile, spawned with a fresh context.',
    external: 'A model from another vendor, called through its CLI.',
    skill: 'A packaged checklist an agent loads to do one kind of task.',
    tool: 'A deterministic script or command. Same input, same output.',
    service: 'An outside service the flow reads or writes.'
  };
  var KIND_ICON = { owner: 'crown', client: 'user', lead: 'spark', agent: 'bot', external: 'hex', skill: 'book', tool: 'term', service: 'cloud' };
  var GATE = {
    owner: { t: 'Your decision', ic: 'hand', cls: '', flag: 'You' },
    review: { t: 'Review gate', ic: 'shield', cls: 'review', flag: 'Review' },
    check: { t: 'Automatic check', ic: 'check', cls: 'check', flag: 'Check' },
    client: { t: 'Waits for the client', ic: 'clock', cls: 'client', flag: 'Client' }
  };

  var ICONS = {
    crown: '<path d="M3 8l4.5 4L12 5l4.5 7L21 8l-2 11H5z"/>',
    user: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/>',
    spark: '<path d="M12 3l1.9 5.6L19.5 10l-5.6 1.9L12 17.5l-1.9-5.6L4.5 10l5.6-1.4z"/><path d="M19 15l.7 2 2 .7-2 .7-.7 2-.7-2-2-.7 2-.7z"/>',
    bot: '<rect x="4" y="8" width="16" height="12" rx="3"/><path d="M12 4v4M9 13v1.5M15 13v1.5M2 13v3M22 13v3"/>',
    hex: '<path d="M12 2.5l8.2 4.75v9.5L12 21.5l-8.2-4.75v-9.5z"/><circle cx="12" cy="12" r="3"/>',
    book: '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20V3H6.5A2.5 2.5 0 0 0 4 5.5z"/><path d="M4 19.5A2.5 2.5 0 0 0 6.5 22H20v-5"/>',
    term: '<rect x="3" y="4" width="18" height="16" rx="2.5"/><path d="M7 9l3 3-3 3M13 15h4"/>',
    cloud: '<path d="M17.5 19a4.5 4.5 0 0 0 .4-9 6 6 0 0 0-11.5 1.6A3.8 3.8 0 0 0 7 19z"/>',
    route: '<circle cx="6" cy="19" r="2.6"/><circle cx="18" cy="5" r="2.6"/><path d="M8.6 19h8.4a3.5 3.5 0 0 0 0-7H7a3.5 3.5 0 0 1 0-7h8.4"/>',
    grid: '<rect x="3" y="3" width="7.5" height="7.5" rx="1.8"/><rect x="13.5" y="3" width="7.5" height="7.5" rx="1.8"/><rect x="3" y="13.5" width="7.5" height="7.5" rx="1.8"/><rect x="13.5" y="13.5" width="7.5" height="7.5" rx="1.8"/>',
    users: '<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c0-3.6 2.9-6.5 6.5-6.5s6.5 2.9 6.5 6.5"/><path d="M16 4.6a3.5 3.5 0 0 1 0 6.8M18.5 13.8c1.8.9 3 2.8 3 5"/>',
    search: '<circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>',
    sun: '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>',
    moon: '<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/>',
    hand: '<path d="M18 11V6a2 2 0 0 0-4 0v5M14 10V4a2 2 0 0 0-4 0v6M10 10.5V6a2 2 0 0 0-4 0v8"/><path d="M18 8a2 2 0 1 1 4 0v6a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.9-6-2.4l-3.6-3.6a2 2 0 0 1 2.8-2.8L7 15"/>',
    pin: '<path d="M12 22s7-6.2 7-12a7 7 0 0 0-14 0c0 5.8 7 12 7 12z"/><circle cx="12" cy="10" r="2.5"/>',
    shield: '<path d="M12 3l8 3v6c0 4.5-3.4 8.3-8 9-4.6-.7-8-4.5-8-9V6z"/><path d="M9 12l2 2 4-4"/>',
    check: '<circle cx="12" cy="12" r="9"/><path d="M8 12l3 3 5-6"/>',
    clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    loop: '<path d="M17 2l4 4-4 4"/><path d="M3 11v-1a4 4 0 0 1 4-4h14"/><path d="M7 22l-4-4 4-4"/><path d="M21 13v1a4 4 0 0 1-4 4H3"/>',
    branch: '<circle cx="6" cy="5.5" r="2.5"/><circle cx="6" cy="18.5" r="2.5"/><circle cx="18" cy="8" r="2.5"/><path d="M6 8v8M18 10.5c0 4.5-6.5 3.5-10.4 6.4"/>',
    right: '<path d="M5 12h14M13 6l6 6-6 6"/>',
    left: '<path d="M19 12H5M11 6l-6 6 6 6"/>',
    x: '<path d="M6 6l12 12M18 6L6 18"/>',
    copy: '<rect x="9" y="9" width="12" height="12" rx="2"/><path d="M5 15V5a2 2 0 0 1 2-2h10"/>',
    doc: '<path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><path d="M14 3v6h6"/>',
    warn: '<path d="M12 3.5l9.5 17h-19z"/><path d="M12 10v4.5M12 17.5v.5"/>',
    list: '<path d="M9 6h12M9 12h12M9 18h12"/><circle cx="4.5" cy="6" r="1.2"/><circle cx="4.5" cy="12" r="1.2"/><circle cx="4.5" cy="18" r="1.2"/>',
    lanes: '<rect x="3" y="4" width="18" height="16" rx="2.5"/><path d="M3 9.5h18M3 14.5h18M9 4v16"/>',
    folder: '<path d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>',
    package: '<path d="M12 2.5l8.5 4.75v9.5L12 21.5l-8.5-4.75v-9.5z"/><path d="M3.5 7.25L12 12l8.5-4.75M12 12v9.5"/>',
    database: '<ellipse cx="12" cy="5.5" rx="8" ry="3"/><path d="M4 5.5v13c0 1.7 3.6 3 8 3s8-1.3 8-3v-13M4 12c0 1.7 3.6 3 8 3s8-1.3 8-3"/>',
    palette: '<path d="M12 21a9 9 0 1 1 9-9c0 2.5-2 3.5-4 3.5h-1.8a1.8 1.8 0 0 0-1.3 3.1A1.6 1.6 0 0 1 12 21z"/><circle cx="7.5" cy="11" r="1.1"/><circle cx="10.5" cy="7" r="1.1"/><circle cx="15.5" cy="7.5" r="1.1"/>',
    lock: '<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>',
    beaker: '<path d="M9 3h6M10 3v6L4.6 18.6A1.6 1.6 0 0 0 6 21h12a1.6 1.6 0 0 0 1.4-2.4L14 9V3"/><path d="M7.2 15h9.6"/>',
    eye: '<path d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
    image: '<rect x="3" y="3" width="18" height="18" rx="2.5"/><circle cx="8.5" cy="8.5" r="1.6"/><path d="M21 15l-5-5L5 21"/>',
    send: '<path d="M22 2L11 13M22 2l-7 20-4-9-9-4z"/>',
    bolt: '<path d="M13 2L3 14h9l-1 8 10-12h-9z"/>',
    board: '<rect x="3" y="3" width="18" height="18" rx="2.5"/><rect x="7" y="7" width="3.5" height="9" rx="1"/><rect x="13.5" y="7" width="3.5" height="5.5" rx="1"/>',
    git: '<circle cx="6" cy="6" r="2.5"/><circle cx="6" cy="18" r="2.5"/><circle cx="18" cy="12" r="2.5"/><path d="M6 8.5v7M8.3 7.2l7.4 3.6"/>',
    cog: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/>',
    compass: '<circle cx="12" cy="12" r="9"/><path d="M15.5 8.5l-2 5-5 2 2-5z"/>',
    dot: '<circle cx="12" cy="12" r="3"/>'
  };

  /* ---------------- helpers ---------------- */
  function h(tag, attrs) {
    var parts = tag.split(/(?=[.#])/), el = document.createElement(parts[0] || 'div');
    for (var i = 1; i < parts.length; i++) {
      if (parts[i][0] === '.') el.classList.add(parts[i].slice(1)); else el.id = parts[i].slice(1);
    }
    if (attrs) Object.keys(attrs).forEach(function (k) {
      var v = attrs[k];
      if (v == null || v === false) return;
      if (k === 'html') el.innerHTML = v;
      else if (k === 'text') el.textContent = v;
      else if (k.slice(0, 2) === 'on') el.addEventListener(k.slice(2), v);
      else if (k === 'class') String(v).split(/\s+/).forEach(function (c) { if (c) el.classList.add(c); });
      else if (k === 'style' && typeof v === 'object') Object.keys(v).forEach(function (s) { el.style.setProperty(s, v[s]); });
      else el.setAttribute(k, v === true ? '' : v);
    });
    for (var j = 2; j < arguments.length; j++) add(el, arguments[j]);
    return el;
  }
  function add(el, kid) {
    if (arguments.length > 2) { for (var i = 1; i < arguments.length; i++) add(el, arguments[i]); return; }
    if (kid == null || kid === false) return;
    if (Array.isArray(kid)) { kid.forEach(function (k) { add(el, k); }); return; }
    el.appendChild(typeof kid === 'object' ? kid : document.createTextNode(String(kid)));
  }
  function svg(tag, attrs) {
    var el = document.createElementNS(NS, tag);
    if (attrs) Object.keys(attrs).forEach(function (k) { if (attrs[k] != null) el.setAttribute(k, attrs[k]); });
    return el;
  }
  function icon(name, cls) {
    var s = svg('svg', { viewBox: '0 0 24 24', 'class': 'i' + (cls ? ' ' + cls : ''), 'aria-hidden': 'true' });
    s.innerHTML = ICONS[name] || ICONS.dot;
    return s;
  }
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; });
  }
  function termOf(t) {
    if (TERMS[t]) return t;
    var low = t.toLowerCase(), hit = null;
    var forms = [low, low.replace(/ies$/, 'y'), low.replace(/es$/, ''), low.replace(/s$/, '')];
    Object.keys(TERMS).forEach(function (k) { if (!hit && forms.indexOf(k.toLowerCase()) >= 0) hit = k; });
    return hit;
  }
  /* inline markup: `Term` (glossary tooltip, else code), **bold**, [[page#id|label]] */
  function md(s) {
    if (s == null) return '';
    var t = esc(s);
    t = t.replace(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g, function (m, tgt, lbl) {
      return '<a href="' + esc(hrefFor(tgt)) + '">' + (lbl || esc(labelFor(tgt))) + '</a>';
    });
    t = t.replace(/`([^`]+)`/g, function (m, c) {
      var raw = c.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
      var k = termOf(raw);
      return k ? '<span class="term" tabindex="0" data-term="' + esc(k) + '">' + c + '</span>' : '<code>' + c + '</code>';
    });
    t = t.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    return t;
  }
  function mdEl(tag, s) { return h(tag, { html: md(s) }); }
  function pageFile(id) { return id === 'index' ? 'index.html' : id + '.html'; }
  function hrefFor(tgt) {
    if (tgt.indexOf('actor:') === 0) return ROSTER ? pageFile(ROSTER.id) + '#focus=' + encodeURIComponent(tgt.slice(6)) : '#';
    var bits = tgt.split('#');
    return pageFile(bits[0] || PID) + (bits[1] ? '#focus=' + encodeURIComponent(bits[1]) : '');
  }
  function labelFor(tgt) {
    if (tgt.indexOf('actor:') === 0) { var a = ACT[tgt.slice(6)]; return a ? a.label : tgt.slice(6); }
    var bits = tgt.split('#'), p = byId[bits[0] || PID];
    if (!p) return tgt;
    if (!bits[1]) return p.title;
    var it = findItem(p, bits[1]);
    return it ? it.title : bits[1];
  }
  function findItem(p, id) {
    var hit = null;
    (p.phases || []).forEach(function (ph) { ph.steps.forEach(function (s) { if (s.id === id) hit = s; }); });
    (p.groups || []).forEach(function (g) { if (g.id === id) hit = g; (g.nodes || []).forEach(function (n) { if (n.id === id) hit = n; }); });
    return hit;
  }
  function actor(id) { return ACT[id] || { label: id, kind: 'tool' }; }
  function kindOf(id) { return actor(id).kind || 'tool'; }
  function av(id, extra) {
    var a = actor(id), k = a.kind || 'tool';
    return h('span.av.k-' + k + (extra ? '.' + extra : ''), { title: a.label, 'aria-hidden': 'true' }, icon(KIND_ICON[k] || 'dot'));
  }
  function modelBadge(a) {
    if (!a.model) return null;
    return h('span.badge.model.k-' + (a.kind || 'tool'), null, a.model, a.effort ? h('span.eff', null, '· ' + a.effort) : null);
  }
  function chip(id, lg) {
    var a = actor(id);
    return h('button.chip.k-' + (a.kind || 'tool') + (lg ? '.lg' : ''), { type: 'button', onclick: function () { openActor(id); },
      title: 'About ' + a.label },
      av(id), a.label, a.model ? h('span.meta', null, a.model + (a.effort ? ' · ' + a.effort : '')) : null);
  }
  function srcHref(path) {
    if (/^https?:\/\//.test(path)) return path;
    if (path.indexOf('ext:') === 0) return null;
    var ref = site.branch || 'main', clean = path;
    if (clean.indexOf('git:') === 0) { var bits = clean.split(':'); ref = bits[1]; clean = bits.slice(2).join(':'); }
    clean = clean.replace(/#.*$/, '').replace(/:\d+(-\d+)?$/, '');
    if (site.repoUrl) return site.repoUrl.replace(/\/$/, '') + '/blob/' + ref + '/' + clean;
    return path.indexOf('git:') === 0 ? null : (site.sourceBase || '../') + clean;
  }
  function srcLabel(s) {
    if (s.indexOf('git:') === 0) { var b = s.split(':'); return b.slice(2).join(':') + ' (on ' + b[1] + ')'; }
    if (s.indexOf('ext:') === 0) return s.slice(4);
    return s;
  }
  function sourcesEl(list) {
    if (!list || !list.length) return null;
    return h('details.sources', null, h('summary', null, icon('doc'), 'Sources', h('span.c', null, list.length)), h('div.srclist', null, list.map(function (s) {
      var href = srcHref(s);
      return href ? h('a', { href: href, target: '_blank', rel: 'noopener', title: 'Open ' + s }, srcLabel(s)) : h('span.src', null, srcLabel(s));
    })));
  }
  function hashState() {
    var q = new URLSearchParams(location.hash.replace(/^#/, '')), o = {};
    q.forEach(function (v, k) { o[k] = v; });
    return o;
  }
  function setHash(patch) {
    var st = hashState();
    Object.keys(patch).forEach(function (k) { if (patch[k] == null) delete st[k]; else st[k] = patch[k]; });
    var s = new URLSearchParams(st).toString();
    history.replaceState(null, '', s ? '#' + s : location.pathname + location.search);
  }
  function lsGet(k) { try { return localStorage.getItem(k); } catch (e) { return null; } }
  function lsSet(k, v) { try { localStorage.setItem(k, v); } catch (e) { /* storage blocked: fine */ } }
  function copyText(t, btn) {
    function ok() { btn.classList.add('ok'); btn.lastChild.textContent = 'Copied'; setTimeout(function () { btn.classList.remove('ok'); btn.lastChild.textContent = 'Copy'; }, 1400); }
    try { navigator.clipboard.writeText(t).then(ok, fallback); } catch (e) { fallback(); }
    function fallback() {
      var ta = h('textarea', { style: { position: 'fixed', opacity: '0' } }); ta.value = t; document.body.appendChild(ta); ta.select();
      try { document.execCommand('copy'); ok(); } catch (e2) { /* nothing */ } ta.remove();
    }
  }

  /* ---------------- theme ---------------- */
  var hs0 = hashState();
  function applyTheme(t) { document.documentElement.setAttribute('data-theme', t || 'auto'); }
  applyTheme(hs0.theme || lsGet('atlas-theme') || 'auto');
  function isDark() {
    var t = document.documentElement.getAttribute('data-theme');
    return t === 'dark' || (t !== 'light' && !(window.matchMedia && matchMedia('(prefers-color-scheme: light)').matches));
  }

  /* ---------------- shell ---------------- */
  var MARK = '<svg class="mark" viewBox="0 0 32 32" aria-hidden="true"><circle cx="16" cy="16" r="14.5" style="fill:var(--panel-3);stroke:var(--line-2);stroke-width:1.2"/>' +
    '<circle cx="16" cy="16" r="10" style="fill:none;stroke:var(--line-2);stroke-width:.8;stroke-dasharray:1.2 2.2"/>' +
    '<path d="M16 4.5L19 16h-6z" style="fill:var(--k-owner)"/><path d="M16 27.5L13 16h6z" style="fill:var(--muted)"/>' +
    '<path d="M4.5 16L16 14v4z" style="fill:var(--faint)"/><path d="M27.5 16L16 18v-4z" style="fill:var(--faint)"/><circle cx="16" cy="16" r="1.8" style="fill:var(--text)"/></svg>';
  var PAGE_ICON = { flow: 'route', system: 'grid', roster: 'users', index: 'compass' };

  function topbar() {
    var nav = h('nav.nav', { 'aria-label': 'Atlas pages' }, pages.map(function (p) {
      return h('a', { href: pageFile(p.id), 'aria-current': p.id === PID ? 'page' : null }, icon(p.icon || PAGE_ICON[p.kind]), p.nav || p.title);
    }));
    var themeBtn = h('button.btn-ghost', { type: 'button', title: 'Light or dark', 'aria-label': 'Toggle light or dark' });
    function paintTheme() { themeBtn.innerHTML = ''; add(themeBtn, icon(isDark() ? 'sun' : 'moon')); }
    themeBtn.addEventListener('click', function () { var t = isDark() ? 'light' : 'dark'; applyTheme(t); lsSet('atlas-theme', t); paintTheme(); redrawAll(); });
    paintTheme();
    return h('header.topbar', null, h('div.wrap', null,
      h('a.brand', { href: 'index.html', html: MARK + '<span>' + esc(site.repo) + ' <small>Atlas</small></span>' }),
      nav,
      h('div.tb-actions', null,
        h('button.btn-ghost.nav-more', { type: 'button', 'aria-label': 'All pages', onclick: openPalette }, icon('list'), 'Pages'),
        h('button.btn-ghost', { type: 'button', onclick: openPalette, 'aria-label': 'Search the atlas' }, icon('search'), h('span.lbl', null, 'Search'), h('kbd.kbd-hint', null, 'Ctrl K')),
        themeBtn)));
  }
  function footer() {
    var v = (build.verified || {})[PID];
    return h('footer.foot', null, h('div.wrap', null,
      h('span', null, 'Built ' + (build.builtAt || '?') + (build.commit ? ' from ' + build.commit : '') +
        (v ? ' · checked against its sources on ' + v.at : ' · not yet checked against its sources')),
      h('span', null, 'Atlas kit ' + (build.kit || '') + ' · refresh with ', h('code', null, '/atlas refresh'))));
  }
  function staleBanner() {
    var st = (build.stale || {})[PID];
    if (!st || !st.length) return null;
    return h('div.banner', { role: 'note' }, icon('warn'), h('div', null,
      h('strong', null, 'This page may be out of date. '),
      st.length + ' source' + (st.length > 1 ? 's' : '') + ' changed since it was last verified: ',
      st.slice(0, 6).map(function (s, i) { return [i ? ', ' : '', h('code', null, s)]; }), st.length > 6 ? ' …' : '',
      '. Ask an agent to run ', h('code', null, '/atlas refresh'), '.'));
  }

  /* ---------------- term tooltip ---------------- */
  var tip = h('div.tip', { role: 'tooltip' });
  function showTip(el) {
    var k = el.getAttribute('data-term'); if (!k) return;
    tip.innerHTML = '<b>' + esc(k) + '</b>' + md(TERMS[k]);
    var r = el.getBoundingClientRect(); tip.classList.add('on');
    var w = tip.offsetWidth, x = Math.min(Math.max(8, r.left + r.width / 2 - w / 2), innerWidth - w - 8);
    var y = r.top - tip.offsetHeight - 10; if (y < 70) y = r.bottom + 10;
    tip.style.left = x + 'px'; tip.style.top = y + 'px';
  }
  function hideTip() { tip.classList.remove('on'); }
  document.addEventListener('mouseover', function (e) { var t = e.target.closest && e.target.closest('.term'); if (t) showTip(t); });
  document.addEventListener('mouseout', function (e) { if (e.target.closest && e.target.closest('.term')) hideTip(); });
  document.addEventListener('focusin', function (e) { if (e.target.classList && e.target.classList.contains('term')) showTip(e.target); });
  document.addEventListener('focusout', hideTip);
  addEventListener('scroll', hideTip, { passive: true });

  /* ---------------- drawer ---------------- */
  var scrim = h('div.scrim', { onclick: function () { closeDrawer(); } });
  var dCrumb = h('div.crumbs'), dNav = h('div.dnav'), dBody = h('div.db'), dFoot = h('div.df');
  var drawer = h('aside.drawer', { 'aria-label': 'Details', role: 'dialog', 'aria-modal': 'true', tabindex: '-1' },
    h('div.dh', null, dCrumb, dNav, h('button.iconbtn', { type: 'button', 'aria-label': 'Close', onclick: function () { closeDrawer(); } }, icon('x'))),
    dBody, dFoot);
  var drawerClose = null, lastFocus = null;
  function openDrawer(opts) {
    if (!drawer.classList.contains('on')) lastFocus = document.activeElement;
    dCrumb.innerHTML = ''; add(dCrumb, opts.crumb); dNav.innerHTML = ''; add(dNav, opts.nav);
    dBody.innerHTML = ''; add(dBody, opts.body); dBody.scrollTop = 0;
    dFoot.innerHTML = ''; add(dFoot, opts.foot); dFoot.style.display = opts.foot ? '' : 'none';
    drawerClose = opts.onClose || null;
    drawer.classList.toggle('instant', !booted); scrim.classList.toggle('instant', !booted);
    drawer.classList.add('on'); scrim.classList.add('on');
    setTimeout(function () { drawer.focus({ preventScroll: true }); }, 30);
  }
  function closeDrawer() {
    if (!drawer.classList.contains('on')) return;
    drawer.classList.remove('on'); scrim.classList.remove('on');
    var cb = drawerClose; drawerClose = null; if (cb) cb();
    if (lastFocus && lastFocus.focus) lastFocus.focus({ preventScroll: true });
  }
  function appearsIn(id) {
    var out = [];
    pages.forEach(function (p) {
      var n = 0;
      (p.phases || []).forEach(function (ph) { ph.steps.forEach(function (s) {
        n++;
        var role = s.actor === id ? 'does' : (s.with || []).indexOf(id) >= 0 ? 'with' : (s.uses || []).indexOf(id) >= 0 ? 'uses' : null;
        if (role) out.push({ page: p, step: s, n: n, role: role });
      }); });
      (p.groups || []).forEach(function (g) { (g.nodes || []).forEach(function (nd) {
        if (nd.actor === id) out.push({ page: p, step: nd, n: null, role: 'node' });
      }); });
    });
    return out;
  }
  function actorBody(id) {
    var a = actor(id), k = a.kind || 'tool', apps = appearsIn(id);
    var rows = [];
    function kv(lbl, val) { if (val) rows.push(h('dt', null, lbl), h('dd', { html: md(val) })); }
    kv('Model', a.model); kv('Effort', a.effort); kv('Tools', a.tools); kv('Access', a.readOnly ? 'Read-only' : a.access);
    kv('Defined in', a.file ? '`' + a.file + '`' : null); kv('Called by', a.calledBy); kv('When', a.when);
    return h('article.stepcard.k-' + k, null,
      h('div.sc-top', null,
        h('div.sc-meta', null, h('span.phase', null, KIND_LABEL[k] || k), a.status === 'planned' ? h('span.badge.planned', null, a.statusLabel || 'Planned, not built') : null),
        h('div', { style: { display: 'flex', gap: '14px', 'align-items': 'center', 'margin-top': '12px' } }, av(id, 'xl'),
          h('h2', { style: { margin: '0' } }, a.label)),
        a.role ? h('p.summary', { style: { 'margin-top': '12px' }, html: md(a.role) }) : null),
      h('div.sc-body', null,
        rows.length ? h('dl.kv', null, rows) : null,
        a.notes ? h('div.blk', null, h('h5', null, 'Worth knowing'), h('ul.does', null, [].concat(a.notes).map(function (n) { return h('li', null, h('span', { html: md(n) })); }))) : null,
        apps.length ? h('div.blk', null, h('h5', null, 'Appears in'), h('ul.applist', null, apps.map(function (x) {
          return h('li', null, h('a', { href: pageFile(x.page.id) + '#focus=' + encodeURIComponent(x.step.id) },
            h('span.dot', { class: 'k-' + kindOf(x.step.actor || id) }), x.step.title,
            h('span.pg', null, x.page.nav || x.page.title, x.n ? ' · step ' + x.n : '', x.role === 'with' ? ' · helps' : x.role === 'uses' ? ' · used' : '')));
        }))) : null,
        sourcesEl(a.sources)));
  }
  function openActor(id) {
    var a = actor(id);
    openDrawer({ crumb: [av(id), h('span', null, a.label)], body: actorBody(id),
      foot: ROSTER && PID !== ROSTER.id ? h('a.btn', { href: pageFile(ROSTER.id) + '#focus=' + encodeURIComponent(id) }, 'Open in ' + (ROSTER.nav || ROSTER.title), icon('right')) : null,
      onClose: PAGE && PAGE.kind === 'roster' ? function () { setHash({ focus: null }); } : null });
  }

  /* ---------------- search palette ---------------- */
  var pIn = h('input', { type: 'search', placeholder: 'Search steps, files, agents, terms…', 'aria-label': 'Search', autocomplete: 'off' });
  var pRes = h('div.res', { role: 'listbox' });
  var palette = h('div.palette', { onclick: function (e) { if (e.target === palette) closePalette(); } },
    h('div.box', null, h('div.in', null, icon('search'), pIn, h('kbd', null, 'Esc')), pRes));
  var INDEX = null, pSel = 0, pItems = [];
  function buildIndex() {
    var ix = [];
    pages.forEach(function (p) {
      ix.push({ t: p.title, d: p.question || p.summary || '', pg: 'Page', href: pageFile(p.id), k: null, ic: p.icon || PAGE_ICON[p.kind] });
      var n = 0;
      (p.phases || []).forEach(function (ph) { ph.steps.forEach(function (s) {
        n++;
        ix.push({ t: s.title, d: [s.summary].concat(s.does || [], s.cmd ? [].concat(s.cmd).map(function (c) { return c.cmd || c; }) : []).join(' · '),
          pg: (p.nav || p.title) + ' · step ' + n, href: pageFile(p.id) + '#focus=' + encodeURIComponent(s.id), k: s.actor });
      }); });
      (p.groups || []).forEach(function (g) { (g.nodes || []).forEach(function (nd) {
        ix.push({ t: nd.title, d: [nd.path, nd.blurb].filter(Boolean).join(' · '), pg: (p.nav || p.title) + ' · ' + g.title,
          href: pageFile(p.id) + '#focus=' + encodeURIComponent(nd.id), k: nd.actor || null, ic: g.icon || 'folder' });
      }); });
    });
    Object.keys(ACT).forEach(function (id) {
      var a = ACT[id];
      ix.push({ t: a.label, d: [KIND_LABEL[a.kind], a.model, a.role].filter(Boolean).join(' · '), pg: 'Who', k: id,
        href: ROSTER ? pageFile(ROSTER.id) + '#focus=' + encodeURIComponent(id) : '#', actorId: id });
    });
    Object.keys(TERMS).forEach(function (t) { ix.push({ t: t, d: TERMS[t], pg: 'Term', k: null, ic: 'book', term: t }); });
    return ix;
  }
  function hl(s, toks) {
    var out = esc(s);
    toks.forEach(function (t) { if (t.length > 1) out = out.replace(new RegExp('(' + t.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'ig'), '<mark>$1</mark>'); });
    return out;
  }
  function runSearch() {
    INDEX = INDEX || buildIndex();
    var q = pIn.value.trim().toLowerCase(), toks = q.split(/\s+/).filter(Boolean);
    var res = !toks.length ? INDEX.filter(function (x) { return x.pg === 'Page'; }) : INDEX.map(function (x) {
      var T = x.t.toLowerCase(), D = (x.d || '').toLowerCase(), sc = 0;
      for (var i = 0; i < toks.length; i++) {
        if (T.indexOf(toks[i]) >= 0) sc += T.indexOf(toks[i]) === 0 ? 6 : 4; else if (D.indexOf(toks[i]) >= 0) sc += 1; else return null;
      }
      return { x: x, sc: sc };
    }).filter(Boolean).sort(function (a, b) { return b.sc - a.sc; }).slice(0, 40).map(function (r) { return r.x; });
    pItems = res; pSel = 0; pRes.innerHTML = '';
    if (!res.length) { add(pRes, h('div.empty', null, 'Nothing matches "' + pIn.value + '".')); return; }
    res.forEach(function (x, i) {
      var lead = x.k && ACT[x.k] ? av(x.k) : h('span.av', null, icon(x.ic || 'dot'));
      var row = h('a.r', { href: x.term ? '#' : x.href, role: 'option', 'data-i': i,
        onclick: function (e) {
          if (x.term) { e.preventDefault(); pIn.value = x.t; }
          closePalette();
          var here = x.href && x.href.split('#')[0] === pageFile(PID);
          if (here && !x.term) { e.preventDefault(); location.hash = x.href.split('#')[1] || ''; onHash(); }
        } },
        lead, h('div', { style: { 'min-width': '0' } }, h('div.tt', { html: hl(x.t, toks) }), x.d ? h('div.ds', { html: hl(String(x.d).slice(0, 160), toks) }) : null),
        h('span.pg', null, x.pg));
      pRes.appendChild(row);
    });
    paintSel();
  }
  function paintSel() { Array.prototype.forEach.call(pRes.querySelectorAll('.r'), function (r, i) { r.classList.toggle('sel', i === pSel); if (i === pSel) r.scrollIntoView({ block: 'nearest' }); }); }
  function openPalette() { palette.classList.add('on'); pIn.value = ''; runSearch(); setTimeout(function () { pIn.focus(); }, 10); }
  function closePalette() { palette.classList.remove('on'); }
  pIn.addEventListener('input', runSearch);
  pIn.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowDown') { pSel = Math.min(pSel + 1, pItems.length - 1); paintSel(); e.preventDefault(); }
    else if (e.key === 'ArrowUp') { pSel = Math.max(pSel - 1, 0); paintSel(); e.preventDefault(); }
    else if (e.key === 'Enter') { var r = pRes.querySelectorAll('.r')[pSel]; if (r) r.click(); e.preventDefault(); }
  });
  document.addEventListener('keydown', function (e) {
    var typing = /INPUT|TEXTAREA/.test((e.target || {}).tagName || '');
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') { e.preventDefault(); palette.classList.contains('on') ? closePalette() : openPalette(); return; }
    if (e.key === 'Escape') { if (palette.classList.contains('on')) closePalette(); else closeDrawer(); return; }
    if (!typing && e.key === '/' && !palette.classList.contains('on')) { e.preventDefault(); openPalette(); return; }
    if (!typing && !palette.classList.contains('on') && keyHandler) keyHandler(e);
  });
  var keyHandler = null;

  /* ---------------- shared hero ---------------- */
  var NARROW = window.matchMedia ? matchMedia('(max-width: 720px)').matches : innerWidth < 720;
  function tldrEl(p) {
    if (!p.tldr || !p.tldr.length) return null;
    var key = 'atlas-tldr-' + p.id, open = lsGet(key);
    var d = h('details.tldr-d', { open: open === '1' ? true : null },
      h('summary', null, icon('list'), 'The short version', h('span.c', null, p.tldr.length + ' points')),
      p.summary ? h('p.lede.tl-sum', { html: md(p.summary) }) : null,
      h('ol.tldr', null, p.tldr.map(function (t, i) { return h('li', null, h('b', null, i + 1), h('span', { html: md(t) })); })));
    d.addEventListener('toggle', function () { lsSet(key, d.open ? '1' : '0'); });
    return d;
  }
  function hero(p, eyebrow, side) {
    return h('section.hero', null, h('div.wrap', null,
      h('div.hero-row', null,
        h('div', null,
          h('div.eyebrow', null, h('span.pill', null, eyebrow)),
          h('h1', { html: md(p.title) }),
          p.question ? h('p.q', null, '“' + p.question + '”') : null,
          p.tldr && p.tldr.length ? null : (p.summary ? h('p.lede', { html: md(p.summary) }) : null),
          tldrEl(p),
          staleBanner()),
        side || null)));
  }
  function nowCard(p, steps, onJump) {
    var st = p.status; if (!st) return null;
    var s = steps && st.step ? steps.filter(function (x) { return x.id === st.step; })[0] : null;
    var waits = [].concat(st.waitingOn || []), mine = !st.paused && waits.some(function (w) { return kindOf(w) === 'owner'; });
    return h('aside.now-card' + (mine ? '.mine' : ''), { 'aria-label': 'Where it stands' },
      h('div.label', null, h('span.pulse'), 'Where it stands', h('span.when', null, 'as of ' + (st.asOf || (site.snapshot || {}).asOf || '?'))),
      h('h3', null, st.title || (s ? 'Step ' + (s._i + 1) + ': ' + s.title : '')),
      st.note ? h('p.clamp', { html: md(st.note), title: 'Click to read all', onclick: function (e) { if (e.target.tagName !== 'A') e.currentTarget.classList.toggle('open'); } }) : null,
      h('div.now-foot', null,
        st.paused ? h('div.waiting.paused', null, icon('clock'), h('span', null, 'Paused at your request')) :
        waits.length ? h('div.waiting', null, h('span', null, 'Waiting on'), waits.map(function (w) { return chip(w); })) : null,
        s && onJump ? h('button.btn.sm', { type: 'button', onclick: function () { onJump(s); } }, icon('pin'), 'Show step ' + (s._i + 1)) : null));
  }
  function legendKinds(ids, extra) {
    var kinds = KIND_ORDER.filter(function (k) { return ids.some(function (id) { return kindOf(id) === k; }); });
    return h('div.legend', null, kinds.map(function (k) { return h('span', null, h('span.dot', { class: 'k-' + k }), KIND_LABEL[k]); }), extra || null);
  }

  /* ---------------- flow ---------------- */
  function flowSteps(p) {
    var steps = [];
    p.phases.forEach(function (ph, pi) { ph.steps.forEach(function (s) { s._ph = ph; s._pi = pi; s._i = steps.length; steps.push(s); }); });
    return steps;
  }
  function gateType(s) { return s.gate ? (s.gate.type || 'owner') : null; }
  function mainNext(steps, s) {
    if (s.next) return [].concat(s.next);
    if (s.end) return [];
    for (var j = s._i + 1; j < steps.length; j++) if (!steps[j].optional) return [steps[j].id];
    return [];
  }
  function cmdEl(c) {
    var cmd = c.cmd || c, btn = h('button.copy', { type: 'button', 'aria-label': 'Copy command' }, icon('copy'), h('span', null, 'Copy'));
    btn.addEventListener('click', function () { copyText(cmd, btn); });
    return h('div.cmd' + (c.who === 'you' ? '.yours' : ''), null, c.who === 'you' ? h('span.who', null, 'You run') : h('span.p', null, '$'), h('code', null, cmd), btn,
      c.note ? h('div.note', { html: md(c.note) }) : null);
  }

  function stepCard(p, s, steps, mode) {
    var k = kindOf(s.actor), gt = gateType(s), g = gt ? GATE[gt] : null, now = p.status && p.status.step;
    var nowStep = now ? steps.filter(function (x) { return x.id === now; })[0] : null;
    var top = h('div.sc-top', null,
      h('div.sc-meta', null,
        h('span.phase', null, s._ph.title),
        h('span', null, 'Step ' + (s._i + 1) + ' of ' + steps.length),
        s.optional ? h('span.badge.optional', null, 'Optional') : null,
        s.state === 'planned' ? h('span.badge.planned', null, 'Planned, not built yet') : null,
        s.state === 'manual' ? h('span.badge.manual', null, 'Done by hand') : null,
        now === s.id ? h('span.here-tag', null, 'You are here') : null,
        mode && mode.go && nowStep && nowStep !== s ? h('button.linkbtn', { type: 'button', onclick: function () { mode.go(nowStep); } }, icon('pin'), 'Now: step ' + (nowStep._i + 1)) : null),
      h('h2', { html: md(s.title) }),
      s.summary ? h('p.summary', { html: md(s.summary) }) : null,
      h('div.sc-actors', null, chip(s.actor, true), s.with && s.with.length ? [h('span.plus', null, 'with'), s.with.map(function (w) { return chip(w); })] : null));
    var body = h('div.sc-body');
    var ownerGate = gt === 'owner';
    if (s.you || ownerGate) add(body, h('div.callout', null, h('span.ic', null, icon('hand')),
      h('div.t', null, s.optional ? 'Your move · optional' : ownerGate ? 'Your decision' : 'Your move'),
      s.you ? h('p', { html: md(s.you) }) : h('p', { html: md(s.gate.label || '') }),
      s.you && ownerGate && s.gate.label ? h('div.sub', { html: md(s.gate.label) }) : null));
    if (g && !ownerGate) add(body, h('div.callout.' + g.cls, null, h('span.ic', null, icon(g.ic)), h('div.t', null, g.t),
      h('p', { html: md(s.gate.label || '') }),
      s.gate.pass || s.gate.cap ? h('div.sub', { html: md([s.gate.pass ? 'Passes when: ' + s.gate.pass : null, s.gate.cap ? 'Limit: ' + s.gate.cap : null].filter(Boolean).join(' · ')) }) : null));
    if (s.does && s.does.length) add(body, h('div.blk', null, h('h5', null, 'What happens'), h('ol.does', null, s.does.map(function (d) { return h('li', null, h('span', { html: md(d) })); }))));
    var ins = s.in && s.in.length, outs = s.out && s.out.length;
    if (ins || outs) add(body, h('div.io' + (ins && outs ? '' : '.one'), null,
      ins ? h('div.col', null, h('h6', null, 'Takes'), h('ul', null, s.in.map(function (x) { return h('li', null, h('span', { html: md(x) })); }))) : null,
      ins && outs ? h('div.arrow', null, icon('right')) : null,
      outs ? h('div.col', null, h('h6', null, 'Produces'), h('ul', null, s.out.map(function (x) { return h('li', null, h('span', { html: md(x) })); }))) : null));
    function stepLink(to) {
      return h('a.to', { href: '#focus=' + to.id, onclick: function (e) { e.preventDefault(); if (mode && mode.go) mode.go(to); } }, 'step ' + (to._i + 1) + ': ' + to.title);
    }
    if (s.loop) {
      var to = steps.filter(function (x) { return x.id === s.loop.to; })[0];
      add(body, h('div.callout.loop', null, h('span.ic', null, icon('loop')), h('div.t', null, to === s ? 'Repeats' : 'Loops back'),
        h('p', null, h('span', { html: md(s.loop.label || 'Not passed') }), to && to !== s ? [' → back to ', stepLink(to)] : null),
        s.loop.cap ? h('div.sub', { html: md('Limit: ' + s.loop.cap) }) : null));
    }
    (s.branch || []).forEach(function (b) {
      var to = steps.filter(function (x) { return x.id === b.to; })[0];
      add(body, h('div.callout.branch', null, h('span.ic', null, icon('branch')), h('div.t', null, 'If ' + (b.when || 'something differs')),
        h('p', null, h('span', { html: md(b.label || '') }), to ? [' → ', stepLink(to)] : null)));
    });
    if (s.cmd && s.cmd.length) add(body, h('div.blk', null, h('h5', null, 'Commands'), h('div.cmds', null, [].concat(s.cmd).map(cmdEl))));
    if (s.uses && s.uses.length) add(body, h('div.blk', null, h('h5', null, 'Uses'), h('div.uses', null, s.uses.map(function (u) {
      var a = actor(u);
      return h('button.use.k-' + (a.kind || 'tool'), { type: 'button', onclick: function () { openActor(u); } }, av(u),
        h('span', null, h('span.nm', null, a.label), a.role ? h('span.ds', { html: md(a.role.split(/(?<=\.)\s/)[0]) }) : null,
          h('span.bd', null, modelBadge(a) || h('span.badge', null, KIND_LABEL[a.kind] || a.kind), a.readOnly ? h('span.badge.ro', null, 'Read-only') : null,
            a.status === 'planned' ? h('span.badge.planned', null, 'Planned') : null)));
    }))));
    if (s.note) add(body, h('div.blk', null, h('h5', null, 'Worth knowing'), h('p.para', { html: md(s.note) })));
    add(body, sourcesEl(s.sources));
    return h('article.panel.stepcard.k-' + k + (s.optional ? '.optional' : ''), { 'data-step': s.id }, top,
      mode && mode.progress ? h('div.progress', null, h('i', { style: { width: ((s._i + 1) / steps.length * 100) + '%' } })) : null, body,
      mode && mode.nav ? mode.nav : null);
  }

  function renderFlow(p, root) {
    var steps = flowSteps(p), byS = {}; steps.forEach(function (s) { byS[s.id] = s; });
    var hs = hashState();
    var view = hs.view === 'story' || hs.view === 'map' ? hs.view : (p.defaultView || 'map');
    var nowS = p.status && byS[p.status.step] ? byS[p.status.step] : null;
    var cur = hs.focus && byS[hs.focus] ? byS[hs.focus]._i : (nowS ? nowS._i : 0);
    var used = [];
    steps.forEach(function (s) { [s.actor].concat(s.with || []).forEach(function (a) { if (used.indexOf(a) < 0) used.push(a); }); });
    var order = used.slice();
    used.sort(function (a, b) { return (KIND_ORDER.indexOf(kindOf(a)) - KIND_ORDER.indexOf(kindOf(b))) || (order.indexOf(a) - order.indexOf(b)); });

    add(root, hero(p, 'Flow · ' + steps.length + ' steps · ' + p.phases.length + ' phases',
      nowCard(p, steps, function (s) { go(s, view === 'map' ? 'map' : 'story', true); })));

    var segMap = h('button', { type: 'button', onclick: function () { setView('map'); } }, icon('lanes'), 'Map');
    var segStory = h('button', { type: 'button', onclick: function () { setView('story'); } }, icon('list'), 'Walk through');
    var legend = legendKinds(used, [h('span', null, h('span.sw-gate'), 'your decision'), h('span', null, h('span.sw-loop'), 'loops back'),
      steps.some(function (s) { return s.optional; }) ? h('span', null, h('span.sw-opt'), 'optional') : null]);
    var metroBox = h('div'), stage = h('div');
    add(root, h('section.section.flow-sec', null, h('div.wrap', null,
      h('div.toolbar', null, h('div.seg', { role: 'group', 'aria-label': 'View' }, segMap, segStory), legend), metroBox, stage)));

    function setView(v) {
      view = v; segMap.setAttribute('aria-pressed', v === 'map'); segStory.setAttribute('aria-pressed', v === 'story');
      setHash({ view: v, focus: v === 'story' ? steps[cur].id : null, open: null });
      closeDrawer(); paint();
    }
    function go(s, v, scroll) {
      cur = s._i;
      if (v && v !== view) { view = v; segMap.setAttribute('aria-pressed', v === 'map'); segStory.setAttribute('aria-pressed', v === 'story'); }
      paint();
      if (view === 'story') { setHash({ view: 'story', focus: s.id }); if (scroll !== false) metroBox.scrollIntoView({ behavior: booted ? 'smooth' : 'auto', block: 'start' }); }
      else if (onMapFocus) { onMapFocus(s); if (scroll) metroBox.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
    }
    var onMapFocus = null, metroDots = {};
    function paint() {
      metroBox.innerHTML = ''; add(metroBox, metro());
      var mEl = metroBox.querySelector('.metro'), cp = mEl && mEl.querySelector('.metro-phase.cur');
      if (cp && mEl.scrollWidth > mEl.clientWidth) mEl.scrollLeft = Math.max(0, cp.offsetLeft - 16);
      stage.innerHTML = ''; onMapFocus = null; mapNav = null;
      if (view === 'story') paintStory(); else paintMap();
    }

    function metro() {
      metroDots = {};
      return h('div.panel.metro-box', null, h('div.metro', { role: 'navigation', 'aria-label': 'All steps' }, p.phases.map(function (ph) {
        var isCur = ph === steps[cur]._ph;
        return h('div.metro-phase' + (isCur ? '.cur' : ''), null, h('div.ph', null, ph.title), h('div.metro-dots', null, ph.steps.map(function (s) {
          var cls = ['mdot', 'k-' + kindOf(s.actor)];
          if (gateType(s) === 'owner') cls.push('gate-owner');
          if (s.optional) cls.push('opt');
          if (view === 'story' && s._i < cur) cls.push('seen');
          if (s._i === cur && (view === 'story' || drawer.classList.contains('on'))) cls.push('cur');
          if (nowS === s) cls.push('here');
          var b = h('button', { type: 'button', 'class': cls.join(' '), title: (s._i + 1) + '. ' + s.title + ' (' + actor(s.actor).label + ')',
            'aria-label': 'Step ' + (s._i + 1) + ': ' + s.title, onclick: function () { go(s); } });
          metroDots[s.id] = b; return b;
        })));
      })), nowS ? h('button.now-jump', { type: 'button', onclick: function () { go(nowS); }, title: 'Jump to where things stand' }, icon('pin'), 'Now · ' + nowS._ph.title + ' · ' + (nowS._i + 1) + ' of ' + steps.length) : null);
    }

    /* walk through */
    function paintStory() {
      var s = steps[cur];
      var back = h('button.btn', { type: 'button', disabled: cur === 0 ? true : null, onclick: function () { go(steps[cur - 1]); } }, icon('left'), 'Back');
      var next = h('button.btn.primary', { type: 'button', disabled: cur === steps.length - 1 ? true : null, onclick: function () { go(steps[cur + 1]); } },
        cur === steps.length - 1 ? 'The end' : 'Next', icon('right'));
      var nav = h('div.stepnav', null, back, h('span.hint', null, h('kbd', null, '←'), h('kbd', null, '→'), 'to move'), next);
      var rail = h('nav.panel.rail', { 'aria-label': 'Steps' }, p.phases.map(function (ph, pi) {
        return [h('h4', null, h('span', null, (pi + 1) + '. ' + ph.title)), h('ol', null, ph.steps.map(function (x) {
          return h('li', null, h('button.k-' + kindOf(x.actor) + (x.optional ? '.opt' : ''), { type: 'button', 'aria-current': x._i === cur ? 'step' : null, onclick: function () { go(x, null, false); } },
            h('span.n' + (gateType(x) === 'owner' ? '.gate-owner' : ''), null, h('span', null, x._i + 1)),
            h('span', null, x.title, nowS === x ? h('span.here-tag', null, 'Now') : null)));
        }))];
      }));
      add(stage, h('div.story', null, rail, stepCard(p, s, steps, { nav: nav, progress: true, go: function (t) { go(t); } })));
      var a = rail.querySelector('[aria-current="step"]'); if (a) rail.scrollTop = Math.max(0, a.offsetTop - rail.clientHeight / 2);
    }
    var mapNav = null;
    keyHandler = function (e) {
      if (drawer.classList.contains('on')) {
        if (mapNav && (e.key === 'ArrowRight' || e.key === 'ArrowLeft')) { mapNav(e.key === 'ArrowRight' ? 1 : -1); e.preventDefault(); }
        return;
      }
      if (view !== 'story') return;
      if (e.key === 'ArrowRight' && cur < steps.length - 1) { go(steps[cur + 1]); e.preventDefault(); }
      if (e.key === 'ArrowLeft' && cur > 0) { go(steps[cur - 1]); e.preventDefault(); }
    };

    /* map: swimlanes */
    function paintMap() {
      var LABEL_W = NARROW ? 74 : 200, COL_W = NARROW ? 168 : 188, NODE_W = NARROW ? 148 : 160, NODE_H = 68, TOP = 48, BOTTOM = 50;
      var MAIN_H = 88, HELP_H = NARROW ? 62 : 48;
      var primary = {}; steps.forEach(function (s) { primary[s.actor] = true; });
      var rows = used, rIdx = {}, rowTop = [], rowH = [], y = TOP;
      rows.forEach(function (a, i) { rIdx[a] = i; rowTop.push(y); rowH.push(primary[a] ? MAIN_H : HELP_H); y += rowH[i]; });
      var W = LABEL_W + steps.length * COL_W + 28, H = y + BOTTOM;
      function nx(i) { return LABEL_W + i * COL_W + (COL_W - NODE_W) / 2; }
      function ny(r) { return rowTop[r] + (rowH[r] - NODE_H) / 2; }
      function cy(r) { return rowTop[r] + rowH[r] / 2; }
      var lanes = h('div.lanes', { style: { width: W + 'px', height: H + 'px' } });
      add(lanes, h('div.lrow.corner', { style: { height: TOP + 'px' } }, h('div.lane-label', { style: { width: LABEL_W + 'px' } })));
      rows.forEach(function (id, i) {
        var a = actor(id);
        add(lanes, h('div.lrow' + (primary[id] ? '' : '.helper'), { style: { height: rowH[i] + 'px' } },
          h('div.lane-label.k-' + (a.kind || 'tool'), { style: { width: LABEL_W + 'px' }, title: a.label + (a.model ? ' · ' + a.model + (a.effort ? ' · ' + a.effort : '') : '') },
            av(id), NARROW ? h('span.mini', null, a.short || a.label) : h('span', null, a.label, primary[id] ? h('span.sub', null, a.model ? a.model + (a.effort ? ' · ' + a.effort : '') : KIND_LABEL[a.kind] || '') : h('span.sub', null, 'helps')))));
      });
      add(lanes, h('div.lrow.corner.bottom', { style: { height: BOTTOM + 'px' } }, h('div.lane-label', { style: { width: LABEL_W + 'px' } })));
      p.phases.forEach(function (ph, pi) {
        var a = ph.steps[0]._i, b = ph.steps[ph.steps.length - 1]._i, x = LABEL_W + a * COL_W, w = (b - a + 1) * COL_W;
        add(lanes, h('div.ph-band' + (pi % 2 ? '.odd' : ''), { style: { left: x + 'px', width: w + 'px' } }));
        add(lanes, h('div.ph-head', { style: { left: x + 'px', width: w + 'px' } }, h('span.num', null, pi + 1), ph.title));
      });
      var g = svg('svg', { 'class': 'edges', width: W, height: H, viewBox: '0 0 ' + W + ' ' + H });
      g.innerHTML = '<defs>' +
        '<marker id="ah" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" style="fill:var(--route)"/></marker>' +
        '<marker id="ahl" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" style="fill:var(--link)"/></marker>' +
        '<marker id="ahb" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" style="fill:var(--warn)"/></marker></defs>';
      add(lanes, g);
      function path(d, cls, a, b, marker) { var e = svg('path', { d: d, 'class': cls, 'data-a': a, 'data-b': b, 'marker-end': marker ? 'url(#' + marker + ')' : null }); g.appendChild(e); return e; }
      var elabels = [];
      function label(x, yy, text, cls, ic) { var el = h('div.elabel' + (cls ? '.' + cls : ''), { style: { left: Math.max(x, LABEL_W + 70) + 'px', top: yy + 'px' } }, ic ? icon(ic) : null, text); el.__x = Math.max(x, LABEL_W + 70); elabels.push(el); add(lanes, el); }
      function link(s, t, cls, marker) {
        var x1 = nx(s._i) + NODE_W, y1 = cy(rIdx[s.actor]), x2 = nx(t._i) - 3, y2 = cy(rIdx[t.actor]), dx = Math.max(26, (x2 - x1) / 2);
        return path(y1 === y2 ? 'M' + x1 + ' ' + y1 + 'H' + x2 : 'M' + x1 + ' ' + y1 + 'C' + (x1 + dx) + ' ' + y1 + ',' + (x2 - dx) + ' ' + y2 + ',' + x2 + ' ' + y2, cls, s.id, t.id, marker);
      }
      steps.forEach(function (s) {
        if (s.optional) {
          for (var j = s._i - 1; j >= 0; j--) if (!steps[j].optional) { link(steps[j], s, 'side'); break; }
          var after = null; for (var k2 = s._i + 1; k2 < steps.length; k2++) if (!steps[k2].optional) { after = steps[k2]; break; }
          if (after) link(s, after, 'side');
        } else mainNext(steps, s).forEach(function (nid) { if (byS[nid]) link(s, byS[nid], 'e', 'ah'); });
        (s.with || []).forEach(function (w) {
          var x = nx(s._i) + NODE_W - 22, yy = cy(rIdx[w]), r0 = rIdx[s.actor], sy = rIdx[w] < r0 ? ny(r0) : ny(r0) + NODE_H;
          path('M' + x + ' ' + sy + 'V' + yy, 'with', s.id, s.id);
          add(lanes, h('div.ghost.k-' + kindOf(w), { title: actor(w).label + ' helps on step ' + (s._i + 1), style: { left: (x - 7) + 'px', top: (yy - 7) + 'px' } }));
          if (NARROW) add(lanes, h('div.ghost-name.k-' + kindOf(w), { style: { left: (x + 12) + 'px', top: (yy - 8) + 'px' } }, actor(w).label));
        });
      });
      var depth = {};
      steps.forEach(function (s) {
        if (s.loop && byS[s.loop.to]) {
          var t = byS[s.loop.to], ra = rIdx[s.actor], rb = rIdx[t.actor], lvl = Math.max(ra, rb);
          depth[lvl] = (depth[lvl] || 0) + 1;
          var yb = ny(lvl) + NODE_H + 12 + (depth[lvl] - 1) * 8, x1 = nx(s._i) + NODE_W / 2 + 14, x2 = nx(t._i) + NODE_W / 2 - 14, y1 = ny(ra) + NODE_H, y2 = ny(rb) + NODE_H, r = 10;
          if (t === s) { x1 = nx(s._i) + NODE_W / 2 + 26; x2 = nx(s._i) + NODE_W / 2 - 26; }
          path('M' + x1 + ' ' + y1 + 'V' + (yb - r) + 'Q' + x1 + ' ' + yb + ' ' + (x1 - r) + ' ' + yb + 'H' + (x2 + r) + 'Q' + x2 + ' ' + yb + ' ' + x2 + ' ' + (yb - r) + 'V' + (y2 + 4), 'loop', s.id, t.id, 'ahl');
          label((x1 + x2) / 2, yb, s.loop.short || s.loop.cap || 'loops back', 'loop', 'loop');
        }
        (s.branch || []).forEach(function (b) {
          var t = byS[b.to]; if (!t) return;
          var x1 = nx(s._i) + NODE_W * 0.3, y1 = ny(rIdx[s.actor]), x2 = nx(t._i) + NODE_W * 0.3, y2 = ny(rIdx[t.actor]), up = Math.min(y1, y2) - 24;
          path('M' + x1 + ' ' + y1 + 'C' + x1 + ' ' + up + ',' + x2 + ' ' + up + ',' + x2 + ' ' + (y2 - 2), 'branch', s.id, t.id, 'ahb');
          label((x1 + x2) / 2, up + 6, b.short || b.when || 'if…', 'branch', 'branch');
        });
      });
      var nodeEls = {};
      steps.forEach(function (s) {
        var gt = gateType(s), x = nx(s._i), yy = ny(rIdx[s.actor]);
        var el = h('button.lnode.k-' + kindOf(s.actor) + (gt === 'owner' ? '.gate-owner' : '') + (s.state === 'planned' ? '.planned' : '') + (s.optional ? '.optional' : ''),
          { type: 'button', style: { left: x + 'px', top: yy + 'px', width: NODE_W + 'px', height: NODE_H + 'px' }, 'aria-label': 'Step ' + (s._i + 1) + ': ' + s.title,
            onclick: function () { openStep(s); },
            onmouseenter: function () { hlEdges(s.id, true); }, onmouseleave: function () { hlEdges(s.id, false); } },
          h('span.m', null, h('span.no', null, String(s._i + 1).padStart(2, '0')),
            NARROW ? h('span.who', null, actor(s.actor).label) : null,
            s.optional ? h('span.tag', null, 'optional') : s.state === 'planned' ? h('span.tag', null, 'planned') : s.loop ? h('span.tag', null, '↺') : null),
          h('span.t', null, s.title),
          gt && !(gt === 'owner' && s.optional) ? h('span.flag' + (GATE[gt].cls ? '.' + GATE[gt].cls : ''), null, icon(GATE[gt].ic), GATE[gt].flag) : null);
        nodeEls[s.id] = el; add(lanes, el);
        if (nowS === s) add(lanes, h('div.here-pin', { style: { left: (x + NODE_W / 2 - (gt ? 22 : 0)) + 'px', top: (yy - (gt ? 40 : 32)) + 'px' } }, h('span.pulse'), 'You are here'));
      });
      function hlEdges(id, on) { Array.prototype.forEach.call(g.querySelectorAll('path'), function (e) { if (e.getAttribute('data-a') === id || e.getAttribute('data-b') === id) e.classList.toggle('hl', on); }); }
      var wrap = h('div.lanes-wrap', null, lanes);
      var cueL = h('button.cue.l', { type: 'button', onclick: function () { wrap.scrollBy({ left: -(wrap.clientWidth - LABEL_W) * 0.8, behavior: 'smooth' }); } }, icon('left'), h('span'));
      var cueR = h('button.cue.r', { type: 'button', onclick: function () { wrap.scrollBy({ left: (wrap.clientWidth - LABEL_W) * 0.8, behavior: 'smooth' }); } }, h('span'), icon('right'));
      var shell = h('div.panel.lanes-shell', { style: { '--lw': LABEL_W + 'px' } },
        h('div.lanes-bar', null, cueL, h('span.bar-hint', null, steps.length + ' steps · ' + rows.length + ' rows'), cueR), wrap);
      add(stage, shell);
      add(stage, h('p.foot-note', null, NARROW ? 'Rows are who acts; tap a card for details. Gold = your decision; dashed blue = loops back.'
        : 'Each row is who acts; each card is one step, left to right. Click a card for the details. Gold = your decision. Dashed blue = loops back. Rings = someone helping on that step.'));
      function visible() {
        var l = wrap.scrollLeft, r = l + wrap.clientWidth, left = 0, right = 0;
        steps.forEach(function (s) {
          var x = nx(s._i), inv = x + NODE_W > l + LABEL_W + 10 && x < r - 10;
          if (nodeEls[s.id]) nodeEls[s.id].classList.toggle('under', x < l + LABEL_W + 30);
          if (x + NODE_W <= l + LABEL_W + 10) left++; else if (x >= r - 10) right++;
          if (metroDots[s.id]) metroDots[s.id].classList.toggle('inview', inv);
        });
        cueL.lastChild.textContent = left + ' earlier'; cueR.firstChild.textContent = right + ' more';
        elabels.forEach(function (el) { el.classList.toggle('gone', el.__x - el.offsetWidth / 2 < l + LABEL_W + 8); });
        cueL.classList.toggle('on', left > 0); cueR.classList.toggle('on', right > 0);
      }
      wrap.addEventListener('scroll', visible, { passive: true });
      if (window.ResizeObserver) new ResizeObserver(visible).observe(wrap);
      function center(s, smooth) {
        var target = nx(s._i) - LABEL_W - (wrap.clientWidth - LABEL_W - NODE_W) / 2;
        wrap.scrollTo({ left: Math.max(0, target), behavior: smooth && booted ? 'smooth' : 'auto' });
      }
      function openStep(s) {
        Object.keys(nodeEls).forEach(function (k) { nodeEls[k].setAttribute('aria-pressed', k === s.id); });
        var el = nodeEls[s.id], r = el.getBoundingClientRect(), wr = wrap.getBoundingClientRect();
        if (r.left < wr.left + LABEL_W || r.right > wr.right - (NARROW ? 0 : 0)) center(s, true);
        cur = s._i; setHash({ focus: s.id, open: '1' });
        Object.keys(metroDots).forEach(function (k) { metroDots[k].classList.toggle('cur', k === s.id); });
        mapNav = function (d) { var t = steps[s._i + d]; if (t) openStep(t); };
        var prev = steps[s._i - 1], nxt = steps[s._i + 1];
        openDrawer({
          crumb: [h('span', null, p.nav || p.title), icon('right'), h('span', null, s._ph.title)],
          nav: [h('button.iconbtn', { type: 'button', 'aria-label': 'Previous step', title: prev ? 'Back: ' + prev.title : '', disabled: prev ? null : true, onclick: function () { mapNav(-1); } }, icon('left')),
            h('button.iconbtn', { type: 'button', 'aria-label': 'Next step', title: nxt ? 'Next: ' + nxt.title : '', disabled: nxt ? null : true, onclick: function () { mapNav(1); } }, icon('right'))],
          body: stepCard(p, s, steps, { go: function (t) { openStep(t); } }),
          foot: [nxt ? h('button.linkbtn', { type: 'button', onclick: function () { mapNav(1); } }, 'Next: ' + nxt.title, icon('right')) : h('span'),
            h('button.btn', { type: 'button', onclick: function () { closeDrawer(); go(s, 'story'); } }, icon('list'), 'Walk through from here')],
          onClose: function () {
            Object.keys(nodeEls).forEach(function (k) { nodeEls[k].setAttribute('aria-pressed', 'false'); });
            Object.keys(metroDots).forEach(function (k) { metroDots[k].classList.remove('cur'); });
            mapNav = null; setHash({ focus: null, open: null });
          }
        });
      }
      onMapFocus = function (s) { openStep(s); };
      var f = hashState().focus;
      setTimeout(function () {
        if (f && byS[f]) { center(byS[f]); openStep(byS[f]); }
        else if (nowS) {
          center(nowS);
          var el = nodeEls[nowS.id], r = el.getBoundingClientRect();
          if (!NARROW && r.bottom + NODE_H + 40 > innerHeight && !hashState().view) {
            // land on today: the map panel's top under the bar, or the current card at 40% height, whichever scrolls less
            var target = Math.min(shell.getBoundingClientRect().top + scrollY - 76, r.top + scrollY - innerHeight * 0.4);
            if (target > 0) requestAnimationFrame(function () { setTimeout(function () { scrollTo(0, target); }, 120); });
          }
        }
        visible();
      }, 0);
    }
    onFocus = function (id) { if (byS[id]) go(byS[id]); };
    segMap.setAttribute('aria-pressed', view === 'map'); segStory.setAttribute('aria-pressed', view === 'story');
    paint();
  }

  /* ---------------- system map ---------------- */
  function renderSystem(p, root) {
    add(root, hero(p, 'Map · ' + p.groups.length + ' areas · ' + (p.edges || []).length + ' links', p.status ? nowCard(p) : null));
    var cols = p.columns || 12;
    var sys = h('div.sys', { style: { 'grid-template-columns': 'repeat(' + cols + ', minmax(0, 1fr))' } });
    var els = {}, items = {}, grpOf = {}, degree = {};
    (p.edges || []).forEach(function (e) { degree[e.from] = (degree[e.from] || 0) + 1; degree[e.to] = (degree[e.to] || 0) + 1; });
    p.groups.forEach(function (gr) {
      var nodes = h('div.nodes', { style: { '--cols': gr.cols || 1 } });
      var gEl = h('section.grp.k-' + (gr.kind || 'tool'), { 'data-id': gr.id, style: { 'grid-column': (gr.col || 'auto') + ' / span ' + (gr.w || 4), 'grid-row': (gr.row || 'auto') + ' / span ' + (gr.h || 1) } },
        h('h3', null, h('span.gi', null, icon(gr.icon || 'folder')), gr.title), gr.blurb ? h('p', { html: md(gr.blurb) }) : null, nodes);
      els[gr.id] = gEl; items[gr.id] = gr;
      (gr.nodes || []).forEach(function (n) {
        var el = h('button.snode.k-' + (n.actor ? kindOf(n.actor) : (gr.kind || 'tool')), { type: 'button', 'data-id': n.id,
          onclick: function () { openNode(n.id); }, onmouseenter: function () { focusOn(n.id); }, onmouseleave: function () { if (!sel) focusOn(null); }, onfocus: function () { focusOn(n.id); } },
          h('span.t', null, n.title, n.state === 'planned' ? h('span.badge.planned', null, 'planned') : null,
            degree[n.id] ? h('span.deg', { title: degree[n.id] + ' link' + (degree[n.id] > 1 ? 's' : '') }, icon('route'), degree[n.id]) : null),
          n.path ? h('span.p', null, n.path) : null, n.blurb ? h('span.b', { html: md(n.blurb) }) : null);
        els[n.id] = el; items[n.id] = n; grpOf[n.id] = gr; add(nodes, el);
      });
      add(sys, gEl);
    });
    var g = svg('svg', { 'class': 'sedges' });
    var wrapEl = h('div.sys-wrap', null, sys, g);
    var allBtn = h('button.fchip', { type: 'button', 'aria-pressed': 'false', onclick: function () {
      var on = allBtn.getAttribute('aria-pressed') !== 'true'; allBtn.setAttribute('aria-pressed', on); g.classList.toggle('all', on); } }, icon('route'), 'Show every link');
    var legend = h('div.legend', null,
      h('span', null, h('span.sw-line'), 'calls or uses'),
      h('span', null, h('span.sw-line.dash'), 'data flows'),
      h('span', null, NARROW ? 'Tap a box for its links.' : 'Hover a box to light up its links; click it for details.'));
    var bb = null;
    if (p.backbone && p.backbone.length) {
      bb = h('div.panel.backbone', null, h('div.bb-h', null, icon('route'), p.backboneTitle || 'The main line'),
        h('div.bb-row', null, p.backbone.map(function (b, i) {
          var n = items[b.node || b], gr = grpOf[b.node || b], k = n && n.actor ? kindOf(n.actor) : (gr ? gr.kind || 'tool' : 'tool');
          return [i ? h('span.bb-arrow', null, b.via ? h('span.via', null, b.via) : null, icon('right')) : null,
            h('button.bb-step.k-' + k, { type: 'button', onclick: function () { onFocus(b.node || b); }, onmouseenter: function () { focusOn(b.node || b); }, onmouseleave: function () { if (!sel) focusOn(null); } },
              h('span.bb-n', null, i + 1), h('span', null, h('b', null, b.label || (n ? n.title : b.node)), gr ? h('small', null, gr.title) : null))];
        })));
    }
    add(root, h('section.section.flow-sec', null, h('div.wrap', null, bb, h('div.toolbar', null, legend, allBtn), wrapEl)));
    var edgeEls = [], labels = [];
    function rel(r, W) { return { left: r.left - W.left, right: r.right - W.left, top: r.top - W.top, bottom: r.bottom - W.top, width: r.width, height: r.height }; }
    function anchor(r, side) {
      return side === 'r' ? [r.right, r.top + r.height / 2] : side === 'l' ? [r.left, r.top + r.height / 2] : side === 'b' ? [r.left + r.width / 2, r.bottom] : [r.left + r.width / 2, r.top];
    }
    function draw() {
      var W = wrapEl.getBoundingClientRect();
      g.setAttribute('width', W.width); g.setAttribute('height', W.height); g.setAttribute('viewBox', '0 0 ' + W.width + ' ' + W.height);
      g.innerHTML = '<defs><marker id="sa" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" style="fill:var(--link)"/></marker></defs>';
      labels.forEach(function (l) { l.remove(); }); labels = []; edgeEls = [];
      (p.edges || []).forEach(function (e) {
        var A1 = els[e.from], B1 = els[e.to]; if (!A1 || !B1) return;
        var a = rel(A1.getBoundingClientRect(), W), b = rel(B1.getBoundingClientRect(), W);
        var dx = (b.left + b.width / 2) - (a.left + a.width / 2), dy = (b.top + b.height / 2) - (a.top + a.height / 2), P1, P2, d;
        var overlapX = a.left < b.right && b.left < a.right;
        if (overlapX && dy) {
          if (grpOf[e.from] && grpOf[e.from] === grpOf[e.to]) {
            P1 = anchor(a, 'r'); P2 = anchor(b, 'r'); var o = 22 + Math.abs(dy) * 0.12;
            d = 'M' + P1[0] + ' ' + P1[1] + 'C' + (P1[0] + o) + ' ' + P1[1] + ',' + (P2[0] + o) + ' ' + P2[1] + ',' + (P2[0] + 3) + ' ' + P2[1];
          } else {
            P1 = anchor(a, dy > 0 ? 'b' : 't'); P2 = anchor(b, dy > 0 ? 't' : 'b'); var c = Math.max(30, Math.abs(P2[1] - P1[1]) / 2);
            d = 'M' + P1[0] + ' ' + P1[1] + 'C' + P1[0] + ' ' + (P1[1] + (dy > 0 ? c : -c)) + ',' + P2[0] + ' ' + (P2[1] - (dy > 0 ? c : -c)) + ',' + P2[0] + ' ' + P2[1];
          }
        } else {
          P1 = anchor(a, dx > 0 ? 'r' : 'l'); P2 = anchor(b, dx > 0 ? 'l' : 'r'); var c2 = Math.max(36, Math.abs(P2[0] - P1[0]) / 2);
          d = 'M' + P1[0] + ' ' + P1[1] + 'C' + (P1[0] + (dx > 0 ? c2 : -c2)) + ' ' + P1[1] + ',' + (P2[0] - (dx > 0 ? c2 : -c2)) + ' ' + P2[1] + ',' + P2[0] + ' ' + P2[1];
        }
        var pe = svg('path', { d: d, 'class': (e.type || 'calls') + (e.core ? ' core' : ''), 'marker-end': 'url(#sa)' });
        pe.__e = e; g.appendChild(pe); edgeEls.push(pe);
        if (e.label) {
          var len = pe.getTotalLength(), m = pe.getPointAtLength(len / 2);
          var l = h('div.slabel' + (e.core ? '.core' : ''), { style: { left: m.x + 'px', top: m.y + 'px' } }, e.label); l.__e = e; labels.push(l); add(wrapEl, l);
        }
      });
      if (sel || hov) focusOn(sel || hov, true);
    }
    var sel = null, hov = null;
    function focusOn(id, keep) {
      if (!keep) hov = id;
      var on = id || sel;
      sys.classList.toggle('focus', !!on); g.classList.toggle('focus', !!on); wrapEl.classList.toggle('focus', !!on);
      Object.keys(els).forEach(function (k) { els[k].classList.remove('hl'); });
      if (on && els[on]) { els[on].classList.add('hl'); if (grpOf[on]) els[grpOf[on].id].classList.add('hl'); }
      edgeEls.forEach(function (pe) {
        var e = pe.__e, hit = on && (e.from === on || e.to === on);
        pe.classList.toggle('hl', !!hit);
        if (hit) { var o = e.from === on ? e.to : e.from; if (els[o]) { els[o].classList.add('hl'); if (grpOf[o]) els[grpOf[o].id].classList.add('hl'); } }
      });
      labels.forEach(function (l) { var e = l.__e; l.classList.toggle('on', !!(on && (e.from === on || e.to === on))); });
    }
    function openNode(id) {
      var n = items[id]; if (!n) return;
      if (sel && els[sel]) els[sel].classList.remove('sel');
      sel = id; els[id].classList.add('sel'); focusOn(id, true); setHash({ focus: id, open: '1' });
      var ins = (p.edges || []).filter(function (e) { return e.to === id; }), outs = (p.edges || []).filter(function (e) { return e.from === id; });
      function linkList(list, dir) {
        return h('ul.applist', null, list.map(function (e) {
          var o = items[dir === 'out' ? e.to : e.from]; if (!o) return null;
          return h('li', null, h('a', { href: '#focus=' + o.id, onclick: function (ev) { ev.preventDefault(); openNode(o.id); } },
            icon(dir === 'out' ? 'right' : 'left'), h('span', null, o.title), h('span.pg', null, e.label || e.type || '')));
        }));
      }
      var gr = grpOf[id], k = n.actor ? kindOf(n.actor) : ((gr || n).kind || 'tool');
      var body = h('article.stepcard.k-' + k, null,
        h('div.sc-top', null, h('div.sc-meta', null, h('span.phase', null, gr ? gr.title : 'Area'), n.state === 'planned' ? h('span.badge.planned', null, 'Planned, not built yet') : null),
          h('h2', null, n.title), n.path ? h('p', { style: { margin: '0 0 8px' } }, h('code', null, n.path)) : null, n.blurb ? h('p.summary', { html: md(n.blurb) }) : null,
          n.actor && actor(n.actor).label !== n.title ? h('div.sc-actors', null, chip(n.actor, true)) : null),
        h('div.sc-body', null,
          n.detail ? h('div.blk', null, h('h5', null, 'What it does'), [].concat(n.detail).length > 1 ? h('ol.does', null, [].concat(n.detail).map(function (d) { return h('li', null, h('span', { html: md(d) })); })) : h('p.para', { html: md(n.detail) })) : null,
          n.touch ? h('div.callout.loop', null, h('span.ic', null, icon('cog')), h('div.t', null, 'Touch it when'), h('p', { html: md(n.touch) })) : null,
          outs.length ? h('div.blk', null, h('h5', null, 'Feeds into'), linkList(outs, 'out')) : null,
          ins.length ? h('div.blk', null, h('h5', null, 'Fed by'), linkList(ins, 'in')) : null,
          !ins.length && !outs.length ? h('p.para.faint', null, 'No mapped links.') : null,
          n.cmd ? h('div.blk', null, h('h5', null, 'Commands'), h('div.cmds', null, [].concat(n.cmd).map(cmdEl))) : null,
          sourcesEl(n.sources || (n.path && !/[<*]/.test(n.path) ? [n.path] : null))));
      openDrawer({ crumb: [h('span', null, p.nav || p.title), icon('right'), h('span', null, gr ? gr.title : n.title)], body: body,
        onClose: function () { if (sel && els[sel]) els[sel].classList.remove('sel'); sel = null; focusOn(null); setHash({ focus: null, open: null }); } });
    }
    onFocus = function (id) { if (items[id]) { els[id].scrollIntoView({ block: 'center', behavior: 'smooth' }); openNode(id); } };
    redraw = draw;
    requestAnimationFrame(draw);
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(draw);
    if (window.ResizeObserver) new ResizeObserver(function () { draw(); }).observe(wrapEl);
    var f = hashState().focus; if (f && items[f]) setTimeout(function () { openNode(f); }, 60);
  }

  /* ---------------- roster ---------------- */
  function renderRoster(p, root) {
    var ids = Object.keys(ACT).filter(function (id) { return !(p.exclude || []).length || p.exclude.indexOf(id) < 0; });
    ids.sort(function (a, b) { return (KIND_ORDER.indexOf(kindOf(a)) - KIND_ORDER.indexOf(kindOf(b))) || ids.indexOf(a) - ids.indexOf(b); });
    var kinds = KIND_ORDER.filter(function (k) { return ids.some(function (id) { return kindOf(id) === k; }); });
    var models = {}; ids.forEach(function (id) { var m = actor(id).model; if (m) models[m] = (models[m] || 0) + 1; });
    add(root, hero(p, 'Who · ' + ids.length + ' actors', h('aside.now-card.models', null,
      h('div.label', null, 'Models in use'),
      h('ul.model-list', null, Object.keys(models).sort(function (a, b) { return models[b] - models[a]; }).map(function (m) {
        var who = ids.filter(function (id) { return actor(id).model === m; });
        var note = (site.modelNotes || {})[m];
        return h('li', null, h('span.mname', null, m), h('span.mcount', null, who.length),
          note ? h('span.mnote', { html: md(note) }) : null, h('span.mwho', null, who.map(function (id) { return actor(id).label; }).join(', ')));
      })))));
    var cards = [], tab = hashState().tab === 'matrix' ? 'matrix' : 'cards';
    var tCards = h('button', { type: 'button', onclick: function () { setTab('cards'); } }, icon('users'), 'Everyone');
    var tMatrix = h('button', { type: 'button', onclick: function () { setTab('matrix'); } }, icon('grid'), 'Who works where');
    var chips = h('div.filters', { role: 'group', 'aria-label': 'Filter' },
      [h('button.fchip', { type: 'button', 'aria-pressed': 'true', 'data-k': 'all', onclick: function () { setF('all'); } }, 'All', h('span.c', null, ids.length))].concat(
        kinds.map(function (k) {
          return h('button.fchip.k-' + k, { type: 'button', 'aria-pressed': 'false', 'data-k': k, onclick: function () { setF(k); } },
            h('span.dot', { class: 'k-' + k }), KIND_LABEL[k], h('span.c', null, ids.filter(function (id) { return kindOf(id) === k; }).length));
        })));
    function setF(k) {
      Array.prototype.forEach.call(chips.children, function (c) { c.setAttribute('aria-pressed', c.getAttribute('data-k') === k); });
      cards.forEach(function (c) { c.el.classList.toggle('dim', k !== 'all' && c.k !== k); });
    }
    var grid = h('div.roster');
    ids.forEach(function (id) {
      var a = actor(id), k = a.kind || 'tool', apps = appearsIn(id), pagesIn = [];
      apps.forEach(function (x) { if (pagesIn.indexOf(x.page) < 0) pagesIn.push(x.page); });
      var el = h('button.rcard.k-' + k + (a.status === 'planned' ? '.planned' : ''), { type: 'button', 'data-id': id, onclick: function () { setHash({ focus: id }); openActor(id); } },
        h('div.hd', null, av(id), h('div', null, h('div.nm', null, a.label), h('div.kd', null, KIND_LABEL[k] || k, a.status === 'planned' ? ' · ' + (a.statusLabel || 'planned').toLowerCase() : ''))),
        a.model ? h('div.mdl', null, h('span.m', null, a.model), a.effort ? h('span.e', null, a.effort + ' effort') : null) : null,
        a.role ? h('p.rl', { html: md(a.role) }) : null,
        h('div.bd', null, a.readOnly ? h('span.badge.ro', null, icon('lock'), 'Read-only') : null, a.file ? h('span.badge', null, icon('doc'), a.file.split('/').pop()) : null),
        h('div.ap', null, apps.length ? h('span', null, 'In ' + apps.length + ' step' + (apps.length > 1 ? 's' : '') + ': ', pagesIn.map(function (pg, i) { return [i ? ', ' : '', h('b', null, pg.nav || pg.title)]; }))
          : h('span', null, 'Not in a mapped flow')));
      cards.push({ el: el, k: k }); add(grid, el);
    });
    var cardsView = h('div', null, h('div.toolbar', null, chips), grid);
    var flows = pages.filter(function (x) { return x.kind === 'flow'; });
    var matrixView = h('div');
    if (flows.length) {
      var t = h('table.matrix');
      add(t, h('tr', null, h('th', null, 'Who'), flows.map(function (f) {
        var n0 = 0;
        return h('th', null, h('a', { href: pageFile(f.id) }, f.nav || f.title), h('span.ph-key', null, f.phases.map(function (ph) {
          var a = n0 + 1, b = n0 + ph.steps.length; n0 = b;
          return h('span', { style: { width: (ph.steps.length * 16 - 3) + 'px' }, title: ph.title + ': steps ' + a + (b > a ? '–' + b : '') }, a === b ? String(a) : a + '–' + b);
        })));
      })));
      var idle = [];
      ids.forEach(function (id) {
        var cells = [], any = false;
        flows.forEach(function (f) {
          var dots = h('span.sq-row');
          var lastPh = null;
          flowSteps(f).forEach(function (s) {
            var r = s.actor === id ? 1 : (s.with || []).indexOf(id) >= 0 || (s.uses || []).indexOf(id) >= 0 ? 2 : 0;
            if (lastPh !== null && s._pi !== lastPh) add(dots, h('span.sq-gap')); lastPh = s._pi;
            if (r) any = true;
            add(dots, h('a.sq.r' + r + '.k-' + kindOf(id), { href: pageFile(f.id) + '#focus=' + encodeURIComponent(s.id), title: (s._i + 1) + '. ' + s.title }));
          });
          cells.push(h('td', null, dots));
        });
        var row = h('tr' + (any ? '' : '.idle'), null, h('td.who', null, av(id), h('span', null, actor(id).label)), cells);
        if (any) add(t, row); else idle.push(row);
      });
      var more = idle.length ? h('button.linkbtn', { type: 'button', onclick: function () { idle.forEach(function (r) { r.classList.toggle('show'); }); more.classList.toggle('open'); } },
        icon('users'), idle.length + ' not in any mapped flow') : null;
      idle.forEach(function (r) { add(t, r); });
      add(matrixView, h('p.para.faint', { style: { margin: '0 0 12px' } }, 'One square per step, in order. Filled = does the step. Ring = helps or is used. Click a square to open that step.'),
        h('div.panel.matrix-wrap', null, t), more);
    }
    function setTab(v) {
      tab = v; tCards.setAttribute('aria-pressed', v === 'cards'); tMatrix.setAttribute('aria-pressed', v === 'matrix');
      cardsView.style.display = v === 'cards' ? '' : 'none'; matrixView.style.display = v === 'matrix' ? '' : 'none';
      setHash({ tab: v === 'matrix' ? 'matrix' : null });
    }
    add(root, h('section.section.flow-sec', null, h('div.wrap', null,
      h('div.toolbar', null, h('div.seg', null, tCards, flows.length ? tMatrix : null)), cardsView, matrixView)));
    setTab(tab);
    onFocus = function (id) { if (ACT[id]) openActor(id); };
    var f = hashState().focus; if (f && ACT[f]) setTimeout(function () { openActor(f); }, 30);
  }

  /* ---------------- index ---------------- */
  function bigMark() {
    var s = '<svg class="mark-xl" viewBox="0 0 300 300" aria-hidden="true"><defs><radialGradient id="mg" cx="50%" cy="45%" r="60%"><stop offset="0" style="stop-color:var(--panel-3)"/><stop offset="1" style="stop-color:var(--bg)"/></radialGradient></defs>';
    s += '<circle cx="150" cy="150" r="138" style="fill:url(#mg);stroke:var(--line-2)"/><circle cx="150" cy="150" r="112" style="fill:none;stroke:var(--line);stroke-dasharray:2 5"/>';
    s += '<ellipse cx="150" cy="150" rx="138" ry="48" style="fill:none;stroke:var(--line)"/><ellipse cx="150" cy="150" rx="48" ry="138" style="fill:none;stroke:var(--line)"/>';
    for (var i = 0; i < 72; i++) {
      var a = i * Math.PI / 36, big = i % 9 === 0, r1 = 138, r2 = big ? 124 : 131;
      s += '<line x1="' + (150 + r1 * Math.sin(a)).toFixed(1) + '" y1="' + (150 - r1 * Math.cos(a)).toFixed(1) + '" x2="' + (150 + r2 * Math.sin(a)).toFixed(1) + '" y2="' + (150 - r2 * Math.cos(a)).toFixed(1) + '" style="stroke:var(' + (big ? '--muted' : '--line-2') + ');stroke-width:' + (big ? 2 : 1) + '"/>';
    }
    [['N', 150, 36], ['E', 268, 155], ['S', 150, 274], ['W', 32, 155]].forEach(function (c) { s += '<text x="' + c[1] + '" y="' + c[2] + '" text-anchor="middle" style="fill:var(--muted);font:700 13px var(--font);letter-spacing:.1em">' + c[0] + '</text>'; });
    s += '<g style="transform-origin:150px 150px;animation:sway 7s ease-in-out infinite"><path d="M150 52L162 150h-24z" style="fill:var(--k-owner)"/><path d="M150 248L138 150h24z" style="fill:var(--faint)"/><circle cx="150" cy="150" r="7" style="fill:var(--text)"/></g>';
    s += '<style>@keyframes sway{0%,100%{transform:rotate(-8deg)}50%{transform:rotate(6deg)}}</style></svg>';
    return s;
  }
  /* a miniature of a flow's swimlanes: rows = actors, one dot per step, the route between them */
  function flowThumb(p) {
    var steps = flowSteps(p), main = [];
    steps.forEach(function (s) { if (main.indexOf(s.actor) < 0) main.push(s.actor); });
    main.sort(function (a, b) { return KIND_ORDER.indexOf(kindOf(a)) - KIND_ORDER.indexOf(kindOf(b)) || 0; });
    var W = 320, rowH = 15, H = main.length * rowH + 14, x0 = 14, dx = (W - 2 * x0) / Math.max(1, steps.length - 1);
    var s = '<svg class="thumb" viewBox="0 0 ' + W + ' ' + H + '" preserveAspectRatio="none" aria-hidden="true">';
    main.forEach(function (a, i) { s += '<line x1="0" x2="' + W + '" y1="' + (7 + i * rowH + rowH / 2) + '" y2="' + (7 + i * rowH + rowH / 2) + '" style="stroke:var(--line);stroke-width:1"/>'; });
    var pts = steps.map(function (st, i) { return [x0 + i * dx, 7 + main.indexOf(st.actor) * rowH + rowH / 2]; });
    s += '<polyline points="' + pts.map(function (q) { return q[0].toFixed(1) + ',' + q[1]; }).join(' ') + '" style="fill:none;stroke:var(--route);stroke-width:1.6;stroke-linejoin:round"/>';
    steps.forEach(function (st, i) {
      var q = pts[i], c = 'var(--k-' + kindOf(st.actor) + ')';
      if (gateType(st) === 'owner') s += '<rect x="' + (q[0] - 4.5) + '" y="' + (q[1] - 4.5) + '" width="9" height="9" transform="rotate(45 ' + q[0] + ' ' + q[1] + ')" style="fill:var(--k-owner)"/>';
      else s += '<circle cx="' + q[0] + '" cy="' + q[1] + '" r="3.6" style="fill:var(--panel);stroke:' + c + ';stroke-width:2"/>';
      if (p.status && p.status.step === st.id) s += '<circle cx="' + q[0] + '" cy="' + q[1] + '" r="8" style="fill:none;stroke:var(--k-owner);stroke-width:2"/>';
    });
    return s + '</svg>';
  }
  function sysThumb(p) {
    var cols = p.columns || 12, rows = 0; p.groups.forEach(function (g) { rows = Math.max(rows, (g.row || 1) + (g.h || 1) - 1); });
    var W = 320, H = rows * 26 + 6, cw = W / cols, s = '<svg class="thumb" viewBox="0 0 ' + W + ' ' + H + '" aria-hidden="true">';
    p.groups.forEach(function (g) {
      var x = ((g.col || 1) - 1) * cw + 3, y = ((g.row || 1) - 1) * 26 + 3, w = (g.w || 4) * cw - 6, hh = (g.h || 1) * 26 - 6;
      s += '<rect x="' + x + '" y="' + y + '" width="' + w + '" height="' + hh + '" rx="5" style="fill:color-mix(in oklab, var(--k-' + (g.kind || 'tool') + ') 14%, var(--panel-2));stroke:color-mix(in oklab, var(--k-' + (g.kind || 'tool') + ') 50%, transparent)"/>';
    });
    return s + '</svg>';
  }
  function renderIndex(root) {
    var snap = site.snapshot || {};
    add(root, h('section.ix-hero', null, h('div.wrap', { style: { position: 'relative' } },
      h('div', { html: bigMark() }),
      h('div.eyebrow', null, h('span.pill', null, 'Atlas'), 'How ' + site.repo + ' works'),
      h('h1', null, h('span', null, site.title || ('The ' + site.repo + ' Atlas'))),
      h('p.lede', { html: md(site.tagline || '') }),
      h('div.meta', null,
        snap.asOf ? h('span.badge', null, icon('clock'), 'Snapshot ' + snap.asOf) : null,
        build.commit ? h('span.badge', null, icon('git'), build.commit) : null,
        h('span.badge', null, icon('users'), Object.keys(ACT).length + ' actors')),
      staleAny())));

    var moves = (site.moves || []).map(function (m) { return { t: m.title, d: m.detail, href: m.to ? hrefFor(m.to) : null, pg: m.to ? labelFor(m.to.split('#')[0]) : '', opt: m.optional }; });
    pages.forEach(function (p) {
      var st = p.status; if (!st || !st.waitingOn || st.paused) return;
      if (![].concat(st.waitingOn).some(function (w) { return kindOf(w) === 'owner'; })) return;
      var s = st.step ? findItem(p, st.step) : null;
      moves.unshift({ t: st.move || (s ? s.title : p.title), d: st.note, href: pageFile(p.id) + (st.step ? '#focus=' + st.step : ''), pg: p.nav || p.title });
    });
    var waits = pages.filter(function (p) { return p.status && !p.status.paused && p.status.waitingOn && ![].concat(p.status.waitingOn).some(function (w) { return kindOf(w) === 'owner'; }); });
    var paused = pages.filter(function (p) { return p.status && p.status.paused; });
    add(root, h('section.section', { style: { 'padding-top': '0' } }, h('div.wrap', null,
      h('div.section-h', null, h('div', null, h('h2', null, 'Your moves'), h('p', null, moves.some(function (m) { return !m.opt; }) ? 'What cannot move until you act comes first.' : 'Nothing is blocked on you right now' + (paused.length ? '; ' + paused.length + (paused.length > 1 ? ' decisions' : ' decision') + ' parked by you.' : '.')))),
      moves.length ? h('div.moves', null, moves.slice().sort(function (a, b) { return (a.opt ? 1 : 0) - (b.opt ? 1 : 0); }).map(function (m) {
        return h(m.href ? 'a.move' : 'div.move', { href: m.href, class: m.opt ? 'opt' : null }, h('span.ic', null, icon('hand')),
          h('div', null, h('div.tt', null, m.opt ? h('span.badge.optional', null, 'Optional') : null, h('span', { html: md(m.t) })), m.d ? h('div.ds', { html: md(m.d) }) : null),
          h('span.go', null, m.pg, m.href ? icon('right') : null));
      })) : h('p.para.faint', null, 'Nothing waits on you.'),
      waits.length ? h('div.others', null, h('span.lbl', null, 'Moving without you:'), waits.map(function (p) {
        return h('a.other', { href: pageFile(p.id) + (p.status.step ? '#focus=' + p.status.step : '') }, [].concat(p.status.waitingOn).map(function (w) { return av(w); }),
          h('span', null, h('b', null, p.nav || p.title), ' · ' + (p.status.title || '')));
      })) : null,
      paused.length ? h('div.moves.paused', null, paused.map(function (p) {
        return h('a.move.paused', { href: pageFile(p.id) + (p.status.step ? '#focus=' + p.status.step : '') }, h('span.ic', null, icon('clock')),
          h('div', null, h('div.tt', null, h('span.badge.optional', null, 'Paused by you'), h('span', null, p.status.move || ('Resume when ready: ' + (p.status.title || p.title)))),
            p.status.note ? h('div.ds', { html: md(p.status.note) }) : null), h('span.go', null, p.nav || p.title, icon('right')));
      })) : null)));

    add(root, h('section.section', null, h('div.wrap', null,
      h('div.section-h', null, h('div', null, h('h2', null, 'Pick a question'), h('p', null, 'Each page answers one. Flows open on a Map; the Walk through goes step by step.'))),
      h('div.cards', null, pages.map(function (p) {
        var foot = null, vis = null;
        if (p.kind === 'flow') {
          var steps = flowSteps(p), cs = p.status && p.status.step ? steps.filter(function (s) { return s.id === p.status.step; })[0] : null;
          vis = h('div.vis', { html: flowThumb(p) });
          foot = h('div.st', null, icon('pin'), cs ? [h('span', null, 'Now at step ' + (cs._i + 1) + ' of ' + steps.length + ': '), h('b', null, cs.title)] : h('span', null, steps.length + ' steps'));
        } else if (p.kind === 'system') {
          var nn = 0; p.groups.forEach(function (g) { nn += (g.nodes || []).length; });
          vis = h('div.vis', { html: sysThumb(p) });
          foot = h('div.st', null, icon('grid'), h('span', null, p.groups.length + ' areas · ' + nn + ' parts · ' + (p.edges || []).length + ' links'));
        } else if (p.kind === 'roster') {
          vis = h('div.vis.avstack', null, Object.keys(ACT).slice(0, 16).map(function (id) { return av(id); }));
          foot = h('div.st', null, icon('users'), h('span', null, Object.keys(ACT).length + ' people, agents, skills and tools, with their models'));
        }
        return h('a.pcard.' + p.kind, { href: pageFile(p.id) },
          h('div.top', null, h('span.kind', null, h('span.ki', null, icon(p.icon || PAGE_ICON[p.kind])), p.kind === 'flow' ? 'Flow' : p.kind === 'system' ? 'Map' : 'Who'), icon('right')),
          h('h3', null, p.title), p.question ? h('p.qq', null, '“' + p.question + '”') : null, vis, foot);
      })))));

    var usedK = KIND_ORDER.filter(function (k) { return Object.keys(ACT).some(function (id) { return kindOf(id) === k; }); });
    add(root, h('section.section', null, h('div.wrap', null,
      h('div.section-h', null, h('div', null, h('h2', null, 'The colour key'), h('p', null, 'The same colour means the same kind of actor on every page.'))),
      h('div.kinds', null, usedK.map(function (k) {
        return h('div.kc.k-' + k, null, h('span.av.k-' + k, null, icon(KIND_ICON[k])), h('div', null, h('b', null, KIND_LABEL[k]), h('span', null, KIND_BLURB[k])));
      })))));
    onFocus = function () {};
  }
  function staleAny() {
    var st = build.stale || {}, ids = Object.keys(st).filter(function (k) { return st[k] && st[k].length; });
    if (!ids.length) return null;
    return h('div.banner', null, icon('warn'), h('div', null, h('strong', null, ids.length + ' page' + (ids.length > 1 ? 's' : '') + ' may be out of date: '),
      ids.map(function (id, i) { return [i ? ', ' : '', h('a', { href: pageFile(id) }, (byId[id] || {}).title || id)]; }), '. Ask an agent to run ', h('code', null, '/atlas refresh'), '.'));
  }

  /* ---------------- boot ---------------- */
  var onFocus = function () {}, redraw = null, booted = false;
  setTimeout(function () { booted = true; }, 800);
  function redrawAll() { if (redraw) requestAnimationFrame(redraw); }
  function onHash() { var f = hashState().focus; if (f) onFocus(f); }
  addEventListener('hashchange', onHash);

  document.title = (PAGE ? PAGE.title.replace(/[`*]/g, '') + ' · ' : '') + site.repo + ' Atlas';
  var main = h('main', { id: 'main' });
  document.body.appendChild(topbar());
  document.body.appendChild(main);
  if (PID === 'index' || !PAGE) renderIndex(main);
  else if (PAGE.kind === 'flow') renderFlow(PAGE, main);
  else if (PAGE.kind === 'system') renderSystem(PAGE, main);
  else if (PAGE.kind === 'roster') renderRoster(PAGE, main);
  document.body.appendChild(footer());
  document.body.appendChild(scrim); document.body.appendChild(drawer); document.body.appendChild(palette); document.body.appendChild(tip);
  var activeNav = document.querySelector('.nav a[aria-current="page"]');
  if (activeNav && activeNav.parentNode.scrollWidth > activeNav.parentNode.clientWidth) activeNav.parentNode.scrollLeft = activeNav.offsetLeft - 16;
  if (hashState().search === '1') openPalette();
})();
