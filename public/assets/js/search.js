// Front end for /search/. Pagefind ships a Default UI (pagefind-ui.js) that
// this deliberately replaces, for one reason: Pagefind has no strict mode.
// When a query word appears in no post, it falls back to a shorter indexed
// word that the query starts with, so "parklife" matches the token "p" and
// "zzqqxvw" matches "z". The Default UI renders those as ordinary results,
// and a reader searching for something unwritten gets confident nonsense
// instead of "nothing found". See isRealWord.

const RESULT_LIMIT = 10;
const SUB_RESULT_LIMIT = 3;
const DEBOUNCE_MS = 200;

const input = document.getElementById('search-input');
const status = document.getElementById('search-status');
const list = document.getElementById('search-results');

let pagefind;
let newest = 0;
let timer;

async function library() {
  if (!pagefind) {
    pagefind = await import('/pagefind/pagefind.js');
    await pagefind.init();
  }
  return pagefind;
}

function normalise(text) {
  return text.replace(/<[^>]*>/g, '').replace(/[^a-z0-9]/gi, '').toLowerCase();
}

// Quoting forces an exact match. Stemming still applies inside the quotes, so
// "testing" finds "tests", which is why this is not a plain index lookup. A
// word that fails the exact test can still be a word half typed, so the loose
// search gets a second say: "stri" is real because it matched "Stripe", and
// "parklife" is not because it only matched "p".
async function isRealWord(pf, word) {
  if ((await pf.search(`"${word}"`)).results.length > 0) return true;

  const loose = await pf.search(word);
  if (loose.results.length === 0) return false;

  const marks = (await loose.results[0].data()).excerpt.match(/<mark>[^<]*<\/mark>/g) || [];
  return marks.some((mark) => normalise(mark).startsWith(normalise(word)));
}

function line(text) {
  status.textContent = text;
}

function resultElement(data) {
  const item = document.createElement('li');
  item.className = 'search-result';

  const heading = document.createElement('a');
  heading.className = 'search-result__title';
  heading.href = data.url;
  heading.textContent = data.meta && data.meta.title ? data.meta.title : data.url;
  item.append(heading);

  const subs = (data.sub_results || [])
    .filter((sub) => sub.title && sub.url !== data.url)
    .slice(0, SUB_RESULT_LIMIT);

  if (subs.length === 0) {
    const excerpt = document.createElement('p');
    excerpt.className = 'search-result__excerpt';
    excerpt.innerHTML = data.excerpt;
    item.append(excerpt);
    return item;
  }

  const nested = document.createElement('ul');
  nested.className = 'search-result__sections';
  subs.forEach((sub) => {
    const section = document.createElement('li');
    const link = document.createElement('a');
    link.href = sub.url;
    link.textContent = sub.title;
    const excerpt = document.createElement('p');
    excerpt.className = 'search-result__excerpt';
    excerpt.innerHTML = sub.excerpt;
    section.append(link, excerpt);
    nested.append(section);
  });
  item.append(nested);
  return item;
}

async function run(query) {
  const token = ++newest;
  const pf = await library();

  const words = query.split(/\s+/).filter(Boolean);
  for (const word of words) {
    if (await isRealWord(pf, word)) continue;
    if (token !== newest) return;
    list.replaceChildren();
    line(`No results for ${query}`);
    return;
  }

  const found = await pf.search(query);
  const data = await Promise.all(found.results.slice(0, RESULT_LIMIT).map((result) => result.data()));
  if (token !== newest) return;

  list.replaceChildren(...data.map(resultElement));
  const total = found.results.length;
  line(`${total} result${total === 1 ? '' : 's'} for ${query}`);
}

input.addEventListener('input', () => {
  clearTimeout(timer);
  const query = input.value.trim();

  if (query === '') {
    newest++;
    list.replaceChildren();
    line('');
    return;
  }

  timer = setTimeout(() => run(query), DEBOUNCE_MS);
});

// The header form submits here with ?q=, so the page picks the query up on
// load. Every other entry point types into the box directly.
const initial = new URLSearchParams(window.location.search).get('q');
if (initial && initial.trim() !== '') {
  input.value = initial;
  run(initial.trim());
}
