# German formats

How numbers, money, dates, units, plurals, variables and long words look in German
UI, and how to produce them. Format at the edge, store canonical values.

Load when: the screen shows or accepts numbers, prices, dates, quantities or counts;
a string holds a variable; a label or button may be too long.

Contents: 1 Locale · 2 Numbers and currency · 3 Parsing German input · 4 Dates and
times · 5 Units and percent · 6 Plurals · 7 Variables in text · 8 Typography ·
9 Long words and text expansion · 10 Strings in code

## 1. Locale

- Default `de-DE`. `<html lang="de">` (or `de-AT`, `de-CH`) drives hyphenation
  and screen reader pronunciation.
- The tenant locale comes from one setting into every `Intl` call, never hard-coded.
- `Intl` handles de-AT and de-CH details when it gets the right locale: `Jänner`,
  currency position, Swiss apostrophe grouping and `CHF`. Swiss text also uses `ss`
  for `ß` and «…» quotes. Never mix variants in one interface.

## 2. Numbers and currency

- Quantities: `new Intl.NumberFormat(locale).format(1234.5)` gives `1.234,5`.
  Prices: `{ style: 'currency', currency: 'EUR' }` gives `12,50 €` (no-break space).
- Decision: thousands grouping with a dot via `Intl`, not the DIN 5008 space style.
- Prices: two decimals. Quantities: only the decimals they have, capped per unit (A).
- Create formatters once, not one per table cell (A). Table numbers are
  right-aligned with tabular figures (`tokens-theming.md` §7).
- Money is computed in integer cents or a decimal type, never as summed floats (A).
- Article numbers, order numbers and postcodes are text: leading zeros stay, no
  grouping (`04711`, never `4.711`).

## 3. Parsing German input

Users type `12,5`; some phone keypads offer only a dot. Rules (A), with an
illustration below (not a library):
1. Strip spaces and no-break spaces.
2. Comma is the decimal separator: `12,5` is 12.5.
3. A dot followed by exactly three digits groups thousands: `1.234` is 1234, never
   1.234. `1.234,56` is 1234.56.
4. A single dot with one or two digits after it may be a decimal (`12.5`).
5. Anything else: reject with a hint (`wording-de.md` §7). Never guess.
6. On blur, show the parsed value back (`12,5`), so the user sees what was understood.
7. Store and send the canonical number, never the display string.

```js
function parseDe(raw) {
  const s = raw.replace(/[\s\u00A0\u202F]/g, '');
  if (/^-?\d{1,3}(\.\d{3})+(,\d+)?$/.test(s))
    return Number(s.replace(/\./g, '').replace(',', '.'));
  if (/^-?\d+(,\d+)?$/.test(s)) return Number(s.replace(',', '.'));
  if (/^-?\d+\.\d{1,2}$/.test(s)) return Number(s);
  return null; // show a hint, keep the input
}
```

Test `12,5`, `1.234`, `1.234,56`, `12.5`, `1 234`, empty, `abc`. Inputs are
`type="text" inputmode="decimal"`, never `type="number"` (`forms-protocols.md` §2).

## 4. Dates and times

| Use | Output | `Intl.DateTimeFormat` options |
|---|---|---|
| Tables, forms | `06.11.2026` | `{ day: '2-digit', month: '2-digit', year: 'numeric' }` |
| Running text | `6. Nov. 2026` | `{ day: 'numeric', month: 'short', year: 'numeric' }` |
| Headings | `Freitag, 6. November 2026` | `{ dateStyle: 'full' }` |
| Time | `14:30 Uhr` | `{ hour: '2-digit', minute: '2-digit' }`, ` Uhr` in the message |
| Relative | `vor 5 Minuten` | `Intl.RelativeTimeFormat` |

- A column headed `Uhrzeit` shows `14:30` without `Uhr`. Relative time keeps the
  absolute time visible (`vor 5 Minuten (14:30 Uhr)`); `title` alone fails touch.
- Calendar weeks as `KW 45` (ISO week, Monday first). `Intl` has no week number:
  use one helper or the date library the project already has; test around New Year.
- Ranges: en dash without spaces, `06.–10.11.2026`, `8–17 Uhr`.
- Data and APIs use ISO 8601 with offset (`2026-11-06T14:30:00+01:00`). Display in
  the tenant time zone, usually `Europe/Berlin`.
- Typed dates accept `6.11.26` and `06.11.2026`. A date input's value is ISO.

## 5. Units and percent

- No-break space between number and unit: `12 m²`, `15 mm`, `24 Stk.`, `50 %`.
  In HTML use `&nbsp;`, or wrap the pair with `white-space: nowrap`.
- `style: 'unit'` knows only simple units (as of 2026-11, re-check). For `m²`,
  `Stk.`, `Pal.` or `Ktn.`, format the number with `Intl` and append the unit.
- Superscript `m²`, `m³`, never `m2`. Dimensions: `30 × 60 cm`. One spelling per
  unit, recorded in the glossary (`wording-de.md` §13). Do not invent abbreviations
  (`Pkg`): use the ERP unit or write the word out (`Paket`).
- A column that shares one unit shows it in the header (`Fläche (m²)`), bare
  numbers in the cells. Mixed units stay in each cell.

## 6. Plurals

German has two categories, `one` and `other`; decimals are `other` (`1,5 Stunden`).
Write zero on its own. Each branch holds the whole phrase, so verbs agree. Never
`Position(en)`, never `count === 1 ? … : …` inside a sentence.

```
{count, plural,
  =0 {Keine Positionen}
  one {# Position wurde übernommen}
  other {# Positionen wurden übernommen}}
```

Without an ICU layer, `Intl.PluralRules` is enough:

```js
const rules = new Intl.PluralRules('de-DE');
const fotos = { one: 'Foto wurde', other: 'Fotos wurden' };
const fotoText = (n) => n === 0 ? 'Keine Fotos hochgeladen'
  : `${n.toLocaleString('de-DE')} ${fotos[rules.select(n)]} hochgeladen`;
```

Check every counted string with 0, 1, 2 and 1.234.

## 7. Variables in text

- One message per sentence with named placeholders. Never glue fragments together.
  A placeholder mid-sentence is fine when the sentence is one message.
- No genitive `-s` on a variable: `{kunde}s Aufträge` breaks for names ending in s,
  x or z. Write `Aufträge von {kunde}`.
- A fixed noun before the variable fixes article and endings:
  `Artikel {nummer} wurde entfernt.`, not `Der {artikel} wurde entfernt.`
- User-supplied names go in German quotes: `Filter „{name}“ gespeichert.`
- No gender assumption in salutations: `Guten Tag {vollerName}`. Brand names are
  not declined.

## 8. Typography

- Quotes „…“ and ‚…‘; Swiss tenants «…» and ‹…›. Never "…".
- En dash without spaces, for ranges only. No em dash: use a colon or a comma.
- Real umlauts and ß in all UI text (`Maße`, `Lösung`). Code identifiers keep theirs.
- `z. B.`, `d. h.` with a no-break space inside; write them out in buttons.
- Ellipsis as one character, space before it: `Wird gespeichert …`.
- No apostrophe for plurals or genitives: `PDFs`, `Annas Aufträge`.

## 9. Long words and text expansion

- Text containers get `hyphens: auto` (needs `lang="de"`) and
  `overflow-wrap: break-word`. `overflow-wrap: anywhere` only as a last resort.
- `hyphens: auto` depends on the browser's German dictionary; support varies by
  browser and platform (as of 2026-11, re-check). For known long words in buttons
  and headings add soft hyphens. Write `&shy;` in HTML or `\u00AD` in JS, because
  the raw character is invisible in review: `Kommissionier&shy;auftrag`.
- Shorter words in navigation when context is clear: `Benachrichtigungen`, not
  `Benachrichtigungseinstellungen`, inside settings.
- Hyphenate compounds with English or abbreviated parts: `PDF-Export`, `CSV-Import`.
- No fixed widths on buttons, tabs, badges or labels. Test the longest real label
  (`Kommissionierauftragsnummer`) at 360 px and 200 % zoom. Truncate only when the
  full text stays reachable by keyboard and touch, never in a status badge.
- Planning hint: German often runs about a third longer than an English draft.
  Leave room; do not treat the figure as measured.

## 10. Strings in code

- All user-facing strings live in a message file per app (`messages/de.json`), not
  in components. Keys name the meaning: `auftrag.freigeben.button`.
- Add a context note where a word is ambiguous: `Abnahme` can mean customer
  acceptance or a drop in stock.
- Tenant overrides (form of address, gender style, glossary terms) load after the
  base messages. The base file is never edited per tenant.
- du and Sie in one core: two message sets, or
  `{anrede, select, du {Gib die Menge ein.} other {Geben Sie die Menge ein.}}`.
- Missing strings fall back to the base locale, never to a raw key. No i18n layer
  yet: one constants module, no new library only for this (A). Check: no German
  string literals in components.
