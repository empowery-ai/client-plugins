---
name: app-design
description: >-
  Baut, prüft und textet die Oberfläche von Web-Apps für Handwerk, Großhandel und
  Mittelstand im DACH-Raum. Drei Modi. Bauen: neue Screens und Komponenten mit
  Design-Tokens, Mandanten-Theming hell und dunkel, dichten Tabellen und Filtern,
  Formularen und langen Protokollen, Handy-Einsatz auf der Baustelle (Handschuhe,
  Sonne, schwaches Netz, offline, Spracheingabe, Kamera). Prüfen: Review bestehender
  Screens, Code oder Screenshots mit festen Prüfblicken, Schweregrad und Bericht,
  Barrierefreiheit nach WCAG 2.2 AA. Texten: deutsche UI-Texte wie du oder Sie,
  Buttons, Fehlermeldungen, Leerzustände, Zahlen und Datum. Nutzen bei Sätzen wie
  „bau die Tabelle“, „prüf den Screen“, „UI-Review“, „Barrierefreiheit checken“,
  „Fehlermeldung formulieren“ oder „Button-Text“. Nicht nutzen für native iOS- oder
  Android-Apps (Swift, Kotlin), Marketing-Landingpages, Werbetexte oder Diagramme.
---

# App Design

Build, review and word the user interface of web apps for small and mid-size firms
in the DACH region: office tools with dense tables, white-label cores with tenant
themes, and phone-first field apps. All UI text is German. This file routes. The
detail lives in `references/`. Load only the files the task needs.

## 1. Pick the mode

| Mode | Use when | Output |
|---|---|---|
| Build | A new screen or component, or a change to one | Code that follows tokens, states, keyboard and wording rules, plus a short verification note |
| Review | Audit of a screen, flow, pull request, code or screenshot | Report in the format of §7 |
| Wording | German UI text: labels, buttons, errors, empty states, numbers, dates | Before/after table (§8) |

- „Mach den Screen besser“: run Review, then Build the fixes in severity order.
- „Prüf mal“ or "review" alone: report only. Do not change code unless asked.
- Wording inside a Build task: apply the wording rules, no separate table.
- Mode unclear: ask one short question, then go.

## 2. Establish context (every mode)

Read before you judge or build:
1. Project instructions: CLAUDE.md, README, design notes, decision records. A
   decision recorded there wins over this skill. Do not report a deliberate decision
   as a defect. If it harms users, say so once under side observations.
2. The token file and theme setup (where `--color-*` and `[data-theme]` live).
3. Existing components and libraries. Reuse before inventing.
4. Wording decisions: du or Sie, gender style, glossary. If none is recorded, ask once
   and suggest recording the answer in the project.

Then pick the profile. Values marked (A) are our assessment, not a standard.

| Profile | Device and users | Widths to check | Targets | Text | Contrast |
|---|---|---|---|---|---|
| Office tool | Desktop browser, mouse and keyboard, office staff | 1280, 1440, 1920; 320 reflow and 200 % zoom | 24 px floor, 32 px for buttons (A) | 14 px in tables (A), 16 px body | WCAG AA |
| White-label core | As the host profile, one design base, many tenants | As host profile, per tenant palette | As host profile | As host profile | AA in every tenant palette, light and dark |
| Field app | Phone, one hand, gloves, sunlight, weak network | 360, 390, 414 portrait, one landscape | 44 px, 48 px gloves, 56 px primary, 64 px main control (A) | 16 px minimum | 7:1 for body text and key labels (A) |

## 3. What to load

Per mode:

| Mode | Always load | Add when needed |
|---|---|---|
| Build | `tokens-theming.md`, `states-feedback.md` | Files from the situation table |
| Review | `review-procedure.md`, `accessibility.md` | `measuring.md` when you can run the app; files from the situation table |
| Wording | `wording-de.md` | `formats-de.md` for numbers, dates, plurals, long words |

Per situation:

| The screen shows or needs | Load |
|---|---|
| A table, a record list, filters, search, an import status page | `tables-filters.md` |
| A form, a long protocol, photos or a signature in a form, a login | `forms-protocols.md` |
| Phone use on site: gloves, sunlight, one hand, voice input, camera, barcode scanner | `field-use.md` |
| Offline work, sync, uploads on a weak network, edit conflicts | `offline-sync.md` |
| Colors, dark and light theme, tenant brand, fonts, spacing, density | `tokens-theming.md` |
| Page structure, navigation, dialog vs side panel vs page, responsive layout | `layout-navigation.md` |
| Loading, empty, error, toast, banner, confirm, undo | `states-feedback.md` |
| Keyboard, focus, screen reader, contrast, target size, any WCAG question | `accessibility.md` |
| Anything that moves: transitions, overlays opening, skeleton shimmer | `motion.md` |
| German text, numbers, dates, currency, units | `wording-de.md`, `formats-de.md` |
| A running app or URL you can measure | `measuring.md` |

## 4. Core principles (every mode)

1. Tokens, not values. Colors, spacing, type, radius and durations come from CSS
   custom properties. No raw hex in components. A tenant changes tokens only.
2. Every view has all its states: loading, empty, error, offline, no permission,
   one item, many items, very long text.
3. Never lose user input: not on network loss, reload, back, error or timeout.
4. Native HTML first (`button`, `a`, `label`, `table`, `dialog`, input types). ARIA
   only where native elements fall short.
5. Keyboard and focus work everywhere: visible focus, logical order, Escape closes,
   focus returns to the trigger.
6. WCAG 2.2 AA is the floor. Field apps aim higher on contrast and target size.
7. One primary action per screen. Calm over clever: no decoration without a job.
8. Numbers are data: right-aligned, tabular figures, German format, units named.
9. Visible feedback within 100 ms of a press. No double submit.
10. Motion only when it explains a change. Respect reduced motion.
11. German UI text, real umlauts, one form of address, one word per action.
12. Evidence over opinion: mark claims Verified or Assessment. Never require a tool.
    Use one when it is available.

## 5. Build mode

1. Context and profile (§2).
2. Tokens: use the existing ones. Add a missing semantic token to the token file, not
   to the component. Check its contrast in both themes and in every tenant palette.
3. Structure: semantic HTML, layout for the profile. Choose dialog, side panel or full
   page with `layout-navigation.md` §4.
4. States: build every state from principle 2, not only the happy path.
5. Interaction: keyboard path, focus handling, target sizes, pending state, double
   submit guard.
6. Motion: only if it helps (`motion.md`).
7. Wording: German text per `wording-de.md`; numbers and dates per `formats-de.md`.
8. Verify by looking: if you can run the app, check the profile widths, both themes
   and one keyboard pass (`measuring.md`). If you cannot, say so.

End with: what you built, what you verified and how, what you did not verify.

## 6. Review mode

Follow `review-procedure.md`. In short:
1. Context and profile (§2). Name the scope: screens, widths, themes, tenant, account.
2. Evidence: measure what you can (`measuring.md`). Confirm code findings at runtime
   before you call them Verified.
3. Run the lenses in this order. Accessibility comes first because it blocks people.

| # | Lens | Main reference |
|---|---|---|
| 1 | Accessibility | `accessibility.md` |
| 2 | Device and context fit | `layout-navigation.md`, `field-use.md` |
| 3 | States and data | `states-feedback.md`, `tables-filters.md`, `forms-protocols.md`, `offline-sync.md` |
| 4 | Visual consistency and tokens | `tokens-theming.md` |
| 5 | Motion, only if something moves | `motion.md` |
| 6 | Wording | `wording-de.md`, `formats-de.md` |

4. Rate severity. The examples in `review-procedure.md` §11 are a floor: a finding at
   least as bad as an example gets at least that level. Rank by user impact, not by
   ease of fix.

| Severity | Meaning |
|---|---|
| Critical | Blocks a core task, loses or corrupts data, or shows wrong business numbers |
| High | Fails a WCAG 2.2 AA criterion, or makes a core task much slower or error-prone |
| Medium | Friction, inconsistency, token drift, a missing secondary state |
| Low | Polish |

5. Report in the format of §7, in the language of the request. After fixes,
   re-measure with the same steps, widths, themes and account; add a before/after table.

## 7. Report format

```markdown
## Summary
Two to four sentences: what was checked, overall state, the biggest risk.
Scope: screens, widths, themes, tenant, test account. Evidence: live, code or screenshot.

## Findings
### [Critical] Short title
- Where: file:line, or screen and element
- Problem: what happens (Verified: how measured | Assessment)
- Why it matters: user impact, rule (WCAG 2.4.11, tables-filters.md §3)
- Fix: the concrete change

(Group findings by root cause. Order: Critical, High, Medium, Low.)

## Quick wins          (low effort, worth doing now)
## What works          (at most three points, so they are kept)
## Not checked         (what and why: no browser, no account, no device)
## Side observations   (out of scope, or deliberate decisions that still hurt users)
```

## 8. Wording mode

1. Read the recorded form of address, gender style and glossary. If missing, ask once.
2. Understand the moment: who reads this, where, what they want to do next.
3. Rewrite per `wording-de.md`. Never invent facts (prices, deadlines, legal claims).
   Mark gaps as `TODO:` in the text.
4. Check numbers, dates, plurals and long words with `formats-de.md`. Output:

| Location | Before | After | Rule |
|---|---|---|---|
| `Abnahme.tsx:42` | Fehler! Ungültige Eingabe. | Geben Sie die Fläche in m² ein, z. B. 12,5. | `wording-de.md` §7 |

Below the table: form of address used, gender style used, open TODOs.

## 9. Evidence and citations

- Cite rules as `file.md §N` plus the WCAG criterion number. Section numbers in the
  reference files are stable.
- Verified: measured or reproduced, say how. Assessment: judgment from code, a
  screenshot or experience. Re-read every cited line before you report it.
- Without a browser, review code and screenshots; runtime claims go to Not checked.
- Use a test account, never real credentials, and name it in the report.
- Do not quote statistics without a source.

Out of scope: native iOS or Android code, marketing landing pages and ad copy,
canvas apps, charts (use a data visualization skill), legal advice.

Sources, upstream mapping and the update check: `SOURCES.md`. Licenses: `NOTICE.md`.
