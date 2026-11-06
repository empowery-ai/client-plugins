# Review procedure

Review mode in full: scope, evidence, the six lenses, severity and the report.
SKILL.md §6 and §7 summarize this file; both must say the same thing.

Load when: any review or audit of a screen, flow, pull request, code or screenshot.

Contents: 1 Establish context · 2 Evidence levels · 3 Lens 1: Accessibility ·
4 Lens 2: Device and context fit · 5 Lens 3: States and data · 6 Lens 4: Visual
consistency and tokens · 7 Lens 5: Motion · 8 Lens 6: Wording · 9 Heuristic
cross-check · 10 Extremes to test · 11 Severity · 12 Rules for findings · 13 Report
format · 14 After fixes

## 1. Establish context

Ask only for what you cannot find. If you assume, say so in the summary.
1. Material: a running app, source code, screenshots or design files. Record what you cannot see.
2. Project rules: CLAUDE.md, README, design notes, decision records, code comments. A
   recorded decision is not a finding. Report only its concrete side effects, marked
   as touching an approved decision.
3. Stack: framework, CSS approach, component library, token file. Fixes use this stack.
4. Profile: Office tool, White-label core or Field app (SKILL.md §2).
5. Users and scope: role (office staff, fitter, warehouse), device, core task;
   screens, widths, themes, tenant palette, account and its role.

## 2. Evidence levels

| Source | Can show | Cannot show |
|---|---|---|
| Running app | All lenses, measured | Sun and gloves, without a real device |
| Code only | Missing labels, `outline: none`, raw hex, missing states, input types | Contrast in context, overflow, focus order, timing |
| Screenshot only | Hierarchy, rough contrast, wording, visual drift | Keyboard, focus, motion, performance, other widths |

- Each finding has one label. Verified: measured or reproduced, with value and method.
  Assessment: judgment, with a way to verify it. "From code" is a source, not a label.
- Confirm code findings at runtime when the app is reachable: an overlay without
  Escape is Verified only after you pressed Escape. Facts that exist only in code (a
  missing media query) can be Verified from code.
- Spot-check what a sub-agent found; until then it is an Assessment. A lens the
  evidence cannot reach goes to Not checked (methods: `measuring.md`, §12 for code).

## 3. Lens 1: Accessibility

Runs first, because failures here lock people out. Details in `accessibility.md`.
- [ ] Core task by keyboard alone, order follows the layout (§3)
- [ ] Visible focus everywhere, not hidden by sticky bars (§4)
- [ ] Overlays: focus in, Escape closes, focus returns (§5)
- [ ] Contrast 4.5:1 and 3:1 in both themes and every tenant palette; no color-only status (§6)
- [ ] Targets meet the profile size or a 2.5.8 exception (§7)
- [ ] Labels, errors tied to fields, summary on long forms (§8)
- [ ] Roles match behavior: tabs are tabs, a single choice is a radio group; `aria-controls`
      points to an element that exists; repeated link texts name their row (§2, 4.1.2, 2.4.4)
- [ ] Saved, sync and import messages reach screen readers (§9)
- [ ] Every drag and swipe has a button alternative (§10)
- [ ] 200 % zoom, 320 px reflow, zoom not blocked (§11)
- [ ] Reduced motion and forced colors respected; icon buttons named (§12, §13)

## 4. Lens 2: Device and context fit

- Widths: Office tool 1280, 1440, 1920. Field app 360, 390, 414 portrait and one
  landscape. White-label core as the host profile. No sideways page scroll.
- Office tool: density fits the task, the sidebar leaves room for the table at
  1280 px, frequent actions have keyboard access.
- Field app: primary action at the bottom within thumb reach, 48 px targets for
  gloves, 7:1 for key labels, nothing needs two hands or a precise tap.
- The on-screen keyboard never hides the focused field or the submit button. Nothing
  needs hover. Details: `layout-navigation.md`, `field-use.md`.

## 5. Lens 3: States and data

Walk the core task with realistic test data, not three tidy rows.
- All states exist: loading, empty, error, partial, offline, no permission, one item,
  many items, very long text (`states-feedback.md`).
- Numbers are correct and formatted (`1.234,56`, `12,50 €`), right-aligned, tabular,
  with units. Totals match their rows.
- Sort, filter, result count, pagination and selection behave (`tables-filters.md`).
- Forms keep input after an error, a reload, back and a timeout (`forms-protocols.md`).
- One press sends one request: no double picking order, no double approval.
- Offline: what is queued, what is blocked, what the user sees (`offline-sync.md`).
- Stale data shows its time (`Stand: 14:30 Uhr`).
- Expandable rows and panels: what happens to an open row that a filter hides, long
  histories capped (`Letzte 5`, `Alle anzeigen`), the click area covers what users try
  to click, view state survives a tab switch (`tables-filters.md` §5, §8).

## 6. Lens 4: Visual consistency and tokens

- Count distinct font sizes, weights and colors (`measuring.md` §6). More values than
  the token scale holds means drift.
- Raw hex or `rgb()` outside the token file is a finding. Spacing follows the 4 px
  scale; spacing inside a group is clearly smaller than between sections.
- One primary action per screen. The accent marks action and key state only.
- Emphasis: the strongest contrast in a row goes to what users scan for (status,
  name), not to an ID pill or a decoration. Hover and selected states are visible.
- A tenant brand color never stands in for danger or success.
- Generated-UI defaults: nested cards, equal-weight buttons, gray-on-gray text,
  gradients or glass as default style, emoji as icons, an icon on every heading.
- Removal test: if nobody would miss an element, it goes. Details:
  `tokens-theming.md`, `layout-navigation.md` §2.

## 7. Lens 5: Motion

Skip when nothing moves, and say so under Not checked. Otherwise check at least
(`motion.md`): press feedback within 100 ms; input never blocked during a transition;
Escape works mid-animation; durations in the canonical ranges with ease-out on enter
and ease-in on exit; only `transform` and `opacity` animate; reduced motion removes
movement and stops the skeleton shimmer.

## 8. Lens 6: Wording

Rules in `wording-de.md` and `formats-de.md`.
- One form of address in the app (du or Sie).
- Buttons name the action (`Lieferschein senden`, not `OK`).
- Errors say what happened and what to do now.
- One word per status and per action across the app. One meaning per word: `Stand`
  is either the status or the data time, not both.
- Developer terms in visible text (`Preset`, `Mapping`, `Job`) are findings; use staff words.
- Real umlauts, German number and date formats, no English leftovers.
- Long compounds wrap or hyphenate; truncated text stays reachable in full.
- Wording findings use the before and after table of SKILL.md §8 inside this report.

## 9. Heuristic cross-check

A final sweep after the lenses, not a report section. A gap found here becomes a
finding in the lens it belongs to.
1. Status visible: the app says what it does (saving, syncing, import step 3 of 5).
2. Real words: staff terms such as Lieferschein and Aufmaß, not system terms.
3. Control: Abbrechen, undo and back work without losing input.
4. Consistency: same thing, same word, same place, same look.
5. Prevention: constraints and defaults; confirm only what cannot be undone.
6. Recognition: show options, recent values, the article name next to its number.
7. Efficiency: shortcuts, bulk actions and saved filters for frequent users.
8. Focus: every element on screen has a job.
9. Recovery: plain error text with cause and next step.
10. Help: short help where the task happens, not a manual elsewhere.

## 10. Extremes to test

Pick what fits the scope; list the rest under Not checked.
- The longest real German label (`Montageprotokollvorlagenverwaltung`) in buttons,
  headers, tabs and columns.
- 0, 1 and 10,000 rows.
- Slow 4G, offline, and the network dropping mid-submit.
- Both themes; the darkest and the lightest tenant accent.
- 200 % zoom and 320 px width.
- A role without permission; a session that expires in the middle of a long form.

## 11. Severity

Four levels, defined in SKILL.md §6. The examples are a floor: a finding at least as
bad as an example gets at least that level. Rank by user impact, not effort. An empty
level is fine.
- Any failed WCAG 2.2 AA criterion is at least High.
- Critical when it blocks a core task, loses or corrupts data, or shows wrong business
  numbers.
- Rating a finding below its floor example needs a reason in the finding.

| Level | Floor examples |
|---|---|
| Critical | Protocol input lost after a network drop. Approve button unreachable by keyboard or covered by the on-screen keyboard. Wrong number format in a price column. Double submit creates two picking orders. Primary text under 3:1. |
| High | Body text under 4.5:1. No visible focus. Target under 24 px without an exception. Error not tied to its field. Status by color only. A toast with an action that disappears. Destructive action with neither undo nor confirm. |
| Medium | Off-token colors. Mixed du and Sie. Missing empty state. Spinner flicker. Transparent sticky header. Left-aligned numbers. |
| Low | Polish: small misalignment, a weak label, spacing off by one step. |

## 12. Rules for findings

- Only what you observed in the app, the code or the screenshot. No generic advice.
- Describe what code does from the function body, never from a name, a comment or a
  guess. Before you report, re-read each cited line against your sentence. A finding
  that contradicts its own citation is a false claim.
- Label each finding Verified or Assessment (§2).
- Cite `file.md §N` plus the WCAG criterion where one applies. Never a bare `§N`.
- Quote numbers: "muted text 3.1:1 on `--color-surface`, needs 4.5:1".
- One root cause, one finding. Group repeats with a count and two examples.
- Credit what works, at most three points. Do not fix unasked; out of scope goes to
  Side observations. Fewer, well-evidenced findings beat a long list.
- No benchmark or conversion numbers without a source; measure the product instead.

## 13. Report format

Write the report in the language of the request; a German request gets German
prose, with file, rule and WCAG references unchanged. Use the template in SKILL.md
§7 unchanged (headings may be translated): Summary, Findings (Critical to Low, by
root cause), Quick wins, What works, Not checked, Side observations. Projects with
Blocker, Major and Minor: Blocker maps to Critical (High for an accessibility failure
that does not block the core task), Major to High or Medium, Minor to Medium or Low.

~~~markdown
### [High] Row actions in the order table have no focus indicator
- Where: `src/components/OrderTable.css:42` (`.row-action { outline: none }`),
  screen „Aufträge“
- Problem: tabbing onto „Bearbeiten“ and „Löschen“ shows no ring in either theme;
  38 of 38 row buttons. Verified: keyboard pass at 1440 px, dark and light, focus
  logged with the snippet in measuring.md §7.
- Why it matters: keyboard users lose their place in a 50-row table. WCAG 2.4.7,
  accessibility.md §4.
- Fix: delete the rule; the shared `:focus-visible` rule then applies
  (`outline: 2px solid var(--color-focus); outline-offset: 2px`).
~~~

Not checked names every lens or extreme you skipped and why (no browser, no account,
no device). A lens missing from both Findings and Not checked is a reporting error.

## 14. After fixes

Re-measure with the same steps, widths, themes, tenant and account; add a table:

| Finding | Before | After | Status |
|---|---|---|---|
| Row action focus | no indicator, 38 of 38 | 2 px ring, 3.8:1 | Fixed |

A fix counts when the measurement shows it, not when the code changed. List new
problems separately, and correct review findings that proved wrong.
