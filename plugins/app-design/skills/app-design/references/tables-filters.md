# Tables and filters

Dense data tables, their filters and search, and the import status page. This is the core of the Office tool profile.

Load when: building or reviewing a table, a record list, a filter bar, a search field, a bulk action, an import status page, or a list on the phone.

Contents: 1 Table or list, 2 Density, alignment and numbers, 3 Sticky header and first column, 4 Sorting, 5 Filters and search, 6 Pagination and virtual scrolling, 7 Selection and bulk actions, 8 Row actions, detail and inline edit, 9 Keyboard, 10 Table states, 11 Import status, 12 Lists on the phone.

## 1. Table or list

| Use | When |
|---|---|
| Table | Users compare several attributes across rows, scan a column, or sort and filter (Aufträge, Lieferscheine, Artikel) |
| List | One main text plus one or two meta values per item, mostly opened one by one (protocols, picking orders on the phone) |
| Cards | Each item carries an image or its own actions (photo gallery of a protocol) |

- A table is a real `table`, not a stack of `div`s. It has a `caption` (visually hidden is fine), `th scope="col"` for columns, and `th scope="row"` for the column that names the row.
- Keep `role="grid"` off a plain table (§9).
- One table answers one question. Two tables glued together with different column sets is two tables.

```html
<table>
  <caption class="visually-hidden">Aufträge, neueste zuerst, 124 Einträge</caption>
  <thead><tr>
    <th scope="col" aria-sort="descending"><button type="button">Datum</button></th>
    <th scope="col">Kunde</th>
    <th scope="col" class="num">Menge (Stk.)</th>
  </tr></thead>
  <tbody><tr><th scope="row">4711</th><td>Fliesenhandel Beispiel</td><td class="num">1.240</td></tr></tbody>
</table>
```

## 2. Density, alignment and numbers

- Row height by density: compact 32 px, default 40 px, comfortable 48 px (A, `tokens-theming.md` §8). Cell text 14 px (`--font-size-sm`). Do not go below 13 px for secondary text.
- Numbers right-aligned, header right-aligned too, with `font-variant-numeric: tabular-nums`. Same number of decimals in a column. Text left-aligned. Check: digits of the thousands place line up across rows.
- German formats in cells: `1.234,56`, `12,50 €` with a no-break space, dates `06.11.2026`. Always via `Intl` (`formats-de.md` §2 and §4).
- Put the unit in the header when the whole column shares it: `Menge (Stk.)`, `Fläche (m²)`, `Preis (€)`. Then cells show only the number. Mixed units stay in the cell.
- Status column: badge with the status word, color extra (`wording-de.md` §9). Status and date columns have a fixed width so the layout does not jump between pages.
- Truncate long text with `text-overflow: ellipsis` only when the full text stays reachable: in a detail panel, a focusable cell with a popover, or `title` as an extra for mouse users. `title` alone does not work on touch or for keyboard users. Never truncate numbers or article numbers.
- Use `table-layout: fixed` with set widths for numbers and status, and one flexible text column.
- Row hover is a light surface step. Selected rows add a visible checked checkbox, not only a background (`tokens-theming.md` §6).
- Zebra stripes are optional. If used, keep both stripe colors within the text contrast pair.
- Allow users to show or hide columns for wide tables (`Spalten`). Persist per user. Do not hide the identifying column.
- Do not cap columns at a fixed number. Cap by what the task needs, then offer column choice.

## 3. Sticky header and first column

A long table keeps its header visible. A wide table keeps its identifying column visible.

```css
.table-scroll { overflow: auto; max-height: 70vh; scroll-padding-top: var(--row-height); }
.table-scroll table { border-collapse: separate; border-spacing: 0; }
thead th { position: sticky; top: 0; z-index: 2; background: var(--color-surface);
  box-shadow: 0 1px 0 var(--color-border); }
tbody th[scope="row"] { position: sticky; left: 0; z-index: 1; background: var(--color-surface); }
thead th:first-child { left: 0; z-index: 3; }
```

- Sticky cells need an opaque background. A translucent header lets rows show through and text collides. Check: scroll one row under the header and read both.
- Use `border-collapse: separate` and draw the header edge with `box-shadow`. With collapsed borders the line scrolls away from a sticky cell (browser behavior, as of 2026-11, re-check).
- The corner cell (first header cell) has the highest `z-index`.
- Scrolling inside the container is the allowed reflow exception for tables (WCAG 1.4.10). The page itself must not scroll sideways at 320 px.
- The scroll container is keyboard reachable: `tabindex="0"`, `role="region"`, `aria-label="Auftragstabelle"`. Without this a keyboard user cannot scroll it.
- `scroll-padding-top` equal to the sticky header height keeps the focused row from hiding under the header (WCAG 2.4.11).
- A sticky first column is worth its width only when a row cannot be identified without it. Keep it narrow.

## 4. Sorting

- A sortable header is a `button` inside the `th`. The `th` carries `aria-sort="ascending"` or `"descending"` on the sorted column only.
- One visible indicator on the active column (an arrow with a text alternative), plus a hover and focus style on the other sortable headers so they look clickable.
- Click cycles ascending, descending. A reset returns to the default sort. The default sort matches the most common task (newest first for Aufträge).
- Ties are broken by a stable second key (the id), so rows do not swap places between reloads.
- Paginated or partially loaded data is sorted on the server. A client sort of one page sorts only the visible page and misleads. Client sort is fine when all rows are loaded.
- German sorting: use a locale collator (`Intl.Collator("de", { numeric: true })`) so `Ä` sorts with `A` and `Artikel 2` comes before `Artikel 10`. Server side: a matching collation. Empty values last, in both directions.
- Sort state is in the URL (§5). Announce a change in a polite live region: `Sortiert nach Datum, absteigend` (`accessibility.md` §9).

## 5. Filters and search

Layout: search field and two to four primary filters in one bar above the table. More filters behind `Weitere Filter` (Hick, `layout-navigation.md` §6). Many dependent filters go in a side panel, or in a bottom sheet on the phone.

Search field:
- Visible by default, not behind an icon on desktop. A visible label or `aria-label`, `type="search"`, container with `role="search"`.
- A hint that names what is searched: `Suche nach Auftragsnummer, Kunde oder Artikel`. A placeholder alone is not a label.
- Debounce typing by 200 to 300 ms (A). Enter searches immediately. A clear button appears when text is present. The query survives back navigation.
- A scanner or pasted article number is typed in and ends with Enter: handle Enter as an exact lookup without waiting for the debounce (`field-use.md` §8).
- Autocomplete only when there is a real list (customers, articles). It follows the combobox pattern with arrow keys and Escape (`accessibility.md` §5).

Matching, German specific:
- Case-insensitive, diacritic-tolerant: `mueller`, `muller` and `Müller` find the same customer; `strasse` finds `Straße`. Normalize both the query and the searched column the same way.
- Article numbers: strip spaces, dashes and dots from query and stored value before comparing. `4711 08` finds `4711-08`. Prefix match on numbers, substring on names. Highlight the matched part.
- Do not require operators or syntax. Support them only as an extra.

Filter controls by data type:

| Data | Control |
|---|---|
| Enum, status | Multi-select checkboxes in a menu; `Status: Offen, In Prüfung` |
| Date | Two date fields (`Von`, `Bis`) plus presets (`Heute`, `Diese Woche`, `Dieser Monat`) |
| Number | Min and max fields, not a slider (precise input matters) |
| Yes or no | A checkbox or switch with a positive label: `Nur Fehlerhafte` |
| Reference (customer, article) | Combobox with search |

Active filters:
- Show each as a chip with a remove button: `Status: Offen`, with `aria-label="Filter Status: Offen entfernen"`. A `Filter zurücksetzen` button appears when any filter is active.
- A result count next to the table title that updates with the filters: `124 Aufträge`. Announce it in a polite live region. A count of 0 shows the zero-result state (§10).
- A filter change resets to page 1 and keeps the sort.
- Filters, sort, page and search are in the URL query string. Reload, back and a shared link then restore the same view. Check: copy the URL into a new tab.
- Filter option counts (`Offen (38)`) only where they are cheap to compute. Gray out zero-count options, do not hide them, so the layout does not shift (A).
- Saved views (`Gespeicherte Ansichten`): a named set of filters, sort and columns, per user, shareable as a link. Offer them once users repeat the same filters daily.

## 6. Pagination and virtual scrolling

Choose by task, not by taste.

| Data and task | Use |
|---|---|
| Work list the user processes and returns to (Aufträge, Lieferscheine) | Pagination, server side |
| Very long list rendered on one page (over about 500 rows in the DOM, (A)) | Virtual scrolling, plus search and filters |
| Exploratory feed with no position to return to | Not our case. No infinite scroll for work lists. |

- Pagination shows the range and total: `1–50 von 124`. Page size choices 25, 50, 100, default 50 for the Office tool (A). Use `nav aria-label="Seitennavigation"`, buttons named `Vorherige Seite`, `Nächste Seite`, the current page with `aria-current="page"`.
- When the total is expensive, show `mehr als 10.000` instead of a slow exact count.
- Infinite scroll hides position, makes Ctrl+F and the footer unreachable, and loses the place on return. It does not fit work lists.
- Virtual scrolling renders only visible rows plus a buffer of 5 to 10. Keep row height fixed so scroll math holds. Set `aria-rowcount` on the table and `aria-rowindex` on rows so screen readers know the true size. Browser find does not see unrendered rows: provide search.
- Keep the position: when the user opens a row and comes back, restore page, sort, filters and scroll offset. Pass this check: open row 37 on page 2, press back, row 37 is on screen.
- Large tables stress responsiveness. Interaction to Next Paint should stay 200 ms or less (web.dev, as of 2026-11). Test sorting and filtering on the largest realistic table with CPU throttling (`measuring.md` §9).

## 7. Selection and bulk actions

- A checkbox column comes first. Each checkbox has a name: `aria-label="Auftrag 4711 auswählen"`. The header checkbox selects the current page and shows the mixed state when only some are selected.
- After a page is selected, offer `Alle 124 Aufträge auswählen` for all results, and `Auswahl aufheben`. Shift plus click selects a range.
- A bulk bar shows the count, `3 ausgewählt`, and the actions. It replaces the toolbar row at the same height so the table does not jump (`layout-navigation.md` §7). Announce the count in a polite live region.
- Selection is cleared by a filter change, a new search, or finishing the action (A). Say so if the user could be surprised.
- A destructive bulk action names the count and the object (`3 Aufträge löschen?`) and offers undo or a confirm (`states-feedback.md` §9).
- Bulk work can partly fail. Report it: `2 von 3 freigegeben, 1 fehlgeschlagen`, with a list of the failed rows and the reason for each. Never show success when one row failed.
- A checkbox column with no bulk action is clutter. Remove it.
- Checkboxes keep a 24 px target even in compact rows.

## 8. Row actions, detail and inline edit

- The row has one explicit link or button to open it, on the identifying cell (`Auftrag 4711`). A whole-row click is an extra for mouse users; the link stays for keyboard and screen readers.
- Other actions: one or two visible buttons with text or a named icon, the rest in a labeled actions menu: `aria-label="Aktionen für Auftrag 4711"`. Icon-only buttons have an accessible name and a tooltip.
- No actions that appear only on row hover. If they appear on hover, they also appear on `:focus-within`, and on touch they are always there.
- Inline edit only for one simple field, like `Menge` or `Notiz`, and only where it saves clicks. Enter saves, Escape cancels, a visible edit border shows the mode. Validate in place. On a failed save, restore the old value and show the error next to the cell.
- Inline edits are small and reversible: update at once and offer undo. Approvals and status changes with consequences are not inline edits (`states-feedback.md` §10).
- Detail opens in a side panel when the user works through a list (`layout-navigation.md` §4). The panel has `Vorheriger` and `Nächster` to step through rows. Single-key shortcuts for this, if any, must be turned off or remapped (WCAG 2.1.4) and must not fire inside inputs.
- Expandable rows show secondary values under the row. The toggle is a button with `aria-expanded`. Use `aria-controls` only when the panel element always exists (render it `hidden`). Long histories show the last five entries and `Alle anzeigen`. When a filter hides an open row, the row closes.
- One decision that covers many rows (a rule, a group, a supplier): show the decisions, not the rows. Each group gets one line with its checkbox and its count, and its rows fold under it, closed by default. Put the groups under one heading with the total (`Artikelzeilen ausgeschlossen (480) in 7 Regeln`) in one visually distinct block, with bold group labels, before any single points. Aim for all groups on one screen at 1440 x 900: when the rows can be opened, drop sample rows and keep one short status line per group. The fold button sits right next to the group label. A group that is ticked but still has an open row shows it while folded (amber status, `1 von 220 Artikelzeilen offen`), so a closed group never hides open work. The request that saves the decision still carries every row id.

## 9. Keyboard

- Default: a plain `table` with native Tab order. Tab goes through sort buttons, filters, then per-row controls. No custom arrow key model is needed.
- Fifty rows with three controls each is 150 tab stops. Reduce: link, checkbox and one menu per row, nothing more. Add a skip link `Zur Tabelle springen` before the filter bar.
- `role="grid"` only with the full WAI-ARIA grid keyboard model: arrow keys between cells, Home and End, Ctrl plus Home and Ctrl plus End, Enter into a cell, Escape out, one tab stop for the grid. A grid with no arrow keys is worse than a plain table.
- `/` may focus the search field. It must be switchable or remappable and ignored while typing (WCAG 2.1.4).
- Focus after actions: delete a row, focus moves to the next row's link, or to the table caption when there is none. New page: focus to the table caption (`tabindex="-1"`) and announce the page. Filter change: focus stays in the filter.
- Focus is always visible and not hidden under the sticky header (§3, WCAG 2.4.7 and 2.4.11).

## 10. Table states

The toolbar and header stay visible in every state. Only the body changes.

| State | Show |
|---|---|
| Loading first time | Skeleton rows at the real row height, as many as the page size up to about 10; `aria-busy="true"` on the region. No indicator under 300 ms. |
| Reloading (sort, filter, page) | Keep the old rows, dim slightly, indicator after 300 ms. Do not blank the table. |
| Empty, first use | What this table will hold and the next action: `Noch keine Lieferscheine. Legen Sie den ersten an.` |
| Empty, filtered | Say which filters are active, offer `Filter zurücksetzen` |
| Empty, no access | Say you lack permission and who can grant it |
| Error | In the body: what failed, `Erneut laden`, a reference code. Keep toolbar and filters. |
| Partial | Mark it: `Teilergebnis, 2 von 3 Quellen geladen` |
| Stale | `Stand: 14:30 Uhr` and a refresh button (`states-feedback.md` §11) |
| Offline | Cached rows with their `Stand:` time (`offline-sync.md` §2) |

Texts: `wording-de.md` §8 and §10. Patterns: `states-feedback.md` §3, §6, §7.

## 11. Import status

An Importlauf runs on the server and can last minutes. The page must stay truthful and useful if the user leaves and comes back.

- Header: run id, file name, who started it, start time, status badge. Status words: `Wartet`, `Läuft`, `Abgeschlossen`, `Mit Fehlern abgeschlossen`, `Fehlgeschlagen` (`wording-de.md` §9).
- Progress while running: determinate bar with named steps (`Datei prüfen`, `Zeilen lesen`, `Artikel anlegen`, `Preise übernehmen`), the current step in text, and `Abbrechen`. State is stored on the server: reloading or returning shows the same run, and the runs list shows all runs.
- Counts that add up: `1.240 Zeilen gelesen, 1.198 importiert, 12 übersprungen, 30 fehlerhaft`. Check: read = imported + skipped + failed. If the numbers do not add up, the page is wrong.
- A run with any failed row is never shown as plain success. Use `Mit Fehlern abgeschlossen`, and a warning color plus icon, not green.
- Error list as a table: `Zeile`, `Spalte`, `Wert`, `Fehler`. Sort by row, filter by error type, search by value. Message text per `wording-de.md` §7: say what is wrong in that cell and what to do.
- A downloadable error report with the same columns plus the original row values, in a format that opens correctly in German Excel (semicolon separator, UTF-8; test it). The user fixes the file and uploads it again.
- `Fehlerhafte Zeilen erneut importieren` reruns only the failed rows. The rerun is idempotent: rows already imported are not created twice (`offline-sync.md` §4).
- Updates: poll every 2 to 5 s while `Läuft` (A), pause when the tab is hidden. Announce progress in a polite live region, throttled to meaningful changes, not every row (`accessibility.md` §9).
- Keep the run reachable for later: users ask `Ist der Import von gestern durchgelaufen?`.

## 12. Lists on the phone

- In the Field app render a real list of items, not a table forced into blocks with CSS. Forcing `display: block` on table parts drops the table semantics and the header association.
- Each item: the key value first (`Kupferrohr 15 mm`), the quantity or status beside it, secondary values below in `--color-text-muted`. Row height at least 56 px, the whole row is one target of at least 48 px. A status badge carries its word.
- Search at the top. Filters in a bottom sheet behind a `Filter` button that shows the active count: `Filter (2)`. Active filters as removable chips under the search.
- No swipe-only actions. Every action also has a visible button or sits in the detail screen.
- Paging on the phone: a `Mehr laden` button with the count `50 von 124`, not infinite scroll. Keep the position on return.
- Rows must work with gloves: no row has two adjacent small controls (`field-use.md` §2).
