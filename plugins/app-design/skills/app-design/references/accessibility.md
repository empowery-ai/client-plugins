# Accessibility

WCAG 2.2 Level AA, applied to the three profiles: Office tool, White-label core and
Field app. This file is lens 1 of a review and the keyboard and focus guide for Build
mode. Each rule says what to check and what passes.

Load when: any review; keyboard, focus, screen reader, contrast, target size or any
WCAG question in Build mode.

Contents: 1 Target and scope · 2 Semantics first · 3 Keyboard · 4 Focus · 5 Dialogs,
menus and overlays · 6 Contrast and color · 7 Target size · 8 Forms · 9 Status messages
and live regions · 10 Pointer, drag and gestures · 11 Text size, zoom and reflow ·
12 User preferences · 13 Images, icons and media

## 1. Target and scope

- Target: WCAG 2.2 AA on every screen. The Field app goes further on contrast (§6)
  and target size (§7); those extras are our rules (A).
- EN 301 549 is the European standard behind public tenders and the European
  Accessibility Act. Its web clauses reference WCAG 2.1 AA (as of 2026-11, re-check),
  so WCAG 2.2 AA covers them.
- The European Accessibility Act (in force since June 2025) mainly covers consumer
  products and services. Internal B2B tools for staff are largely outside it. Public
  sector clients have their own rules. This is not legal advice; say so when asked.
- WCAG 3 is a working draft: do not target it. APCA is an extra readability check at
  most, never pass or fail.
- Every accessibility finding cites the success criterion number ("WCAG 2.4.11").

## 2. Semantics first

Native elements bring role, name, state and keyboard behavior. ARIA only fills gaps.
- Landmarks as elements (`header`, `nav`, one `main`, `footer`), not `div role=...`.
- One `h1` per view, heading levels without gaps, never chosen for font size.
- `button` acts on this page, `a href` goes somewhere. A clickable `div`, or an `a`
  without `href` used as a button, is a finding.
- Lists are `ul` or `ol`; data grids are `table` with `th` (`tables-filters.md` §1).
- ARIA state follows the real state: `aria-expanded` flips when the panel opens.
- Wrong ARIA is worse than none. Avoid:
  - `role="alert"` plus `aria-live="assertive"`; the role already implies it.
  - `aria-hidden="true"` on visible or focusable content such as an open menu. Hide
    closed content with the `hidden` attribute.
  - `div tabindex="0" role="button"` where a `button` would do.

## 3. Keyboard

- Every function works by keyboard (2.1.1). Pass: approve an Importlauf, fill a
  protocol section and filter Aufträge with the mouse unplugged.
- Tab order follows the visual order (2.4.3). No `tabindex` above 0.
- No trap (2.1.2). Inside a modal dialog Tab cycles on purpose; Escape leaves.
- A skip link „Zum Inhalt springen“ is the first focusable element and shows on focus
  (2.4.1), wherever a header or sidebar comes before the content.
- Keys: Enter activates links and buttons; Space activates buttons and checkboxes;
  arrows move inside radio groups, tabs, menus and listboxes; Escape closes overlays.
- Single-key shortcuts (`n` for a new Auftrag) can be turned off or remapped, or work
  only while their component has focus (2.1.4). Do not override browser shortcuts
  such as Strg+F (A).
- Row actions that appear on hover also appear on `:focus-within`.

## 4. Focus

- Every focusable element shows a visible indicator (2.4.7), via `:focus-visible`.
- At least 2 px thick (A), 3:1 against its neighbors (1.4.11), color from
  `--color-focus`, checked in both themes and every tenant palette.
- `outline: none` without a replacement is a High finding.
- Use `outline`, not `box-shadow`: outlines survive forced colors mode.

```css
:where(a, button, input, select, textarea, summary, [tabindex]):focus-visible {
  outline: 2px solid var(--color-focus);
  outline-offset: 2px;
}
```

- Focus not obscured (2.4.11): a sticky header, a sticky action bar, a toast or a
  banner never fully covers the focused element. Set `scroll-padding-block-start`
  and `-end` on `html` to the sticky bar heights. Pass: tab through a long form at
  390 px and 1280 px; each focused element stays at least partly visible.
- Route change in a single-page app: focus moves to the new `h1` (`tabindex="-1"`),
  and `document.title` changes.
- After a delete, focus goes to the next row or the list heading, never to `body`.
- After a dialog or panel closes, focus returns to its trigger.

## 5. Dialogs, menus and overlays

- Modal dialogs use the native `dialog` element with `showModal()`: top layer, Escape
  closes, background inert (browser support as of 2026-11, re-check).
- On open, focus goes to the first useful control. In a destructive confirm dialog
  („Lieferschein LS-2041 löschen?“) that is the safe choice, `Abbrechen`.
- `aria-labelledby` names the dialog by its heading. A visible scrim marks the
  background as unavailable.
- Escape closes. With unsaved input, ask before discarding.
- On close, focus returns to the trigger. Check it, do not assume it.
- Never a dialog on top of a dialog (`layout-navigation.md` §4).
- Non-modal side panels do not trap focus; Escape closes them and focus returns.
- Menus, comboboxes, tabs and trees follow the WAI-ARIA Authoring Practices keyboard
  patterns. A half-built widget is worse than a native `select` or `details`.

Runtime check (`measuring.md` §7): open, Tab through, press Escape, read
`document.activeElement` before and after. Pass: focus starts inside, never reaches
the page behind, and ends on the trigger.

## 6. Contrast and color

| Content | Minimum | Source |
|---|---|---|
| Normal text | 4.5:1 | WCAG 1.4.3 |
| Large text (24 px regular, or about 18.7 px bold) | 3:1 | WCAG 1.4.3 |
| UI component boundaries, meaningful icons, focus indicator | 3:1 | WCAG 1.4.11 |
| Field app body text and key labels | 7:1 | (A), same number as WCAG 1.4.6 AAA |

- Usual failures: placeholders, muted meta text in table rows, text on accent
  buttons, status chips, input borders.
- Disabled controls are exempt from 1.4.3; keep them readable anyway (A,
  `tokens-theming.md` §10).
- Check every pair in the dark default, the light theme and every tenant palette. The
  tenant accent with `--color-on-accent` text is the riskiest pair.
- Never color alone (1.4.1): a status chip carries text („Freigegeben“), an error has
  icon and text, links in running text are underlined.
- Text on a photo cannot be measured by DOM tools. Check the worst spot with a color
  picker, or put the text on a solid surface.

## 7. Target size

WCAG 2.5.8 sets a floor of 24 × 24 CSS px. Smaller passes only with an exception:
- Spacing: a 24 px circle centered on the target touches no other target or circle.
- Equivalent: the same function exists elsewhere on the page at full size.
- Inline: the target sits inside a sentence or text block.
- User agent: a native control the page has not restyled.
- Essential: the size is required by law or by the information shown.

| Profile | Size | Status |
|---|---|---|
| Office tool | 24 px floor in dense rows, 32 px for buttons | (A) |
| White-label core | As the host profile | (A) |
| Field app | 44 × 44 px default, 48 px with gloves, 56 px for primary actions, 64 px for the one main control, gap at least 8 px | (A) |

Measure the hit area, not the glyph. Padding or an absolutely positioned `::before`
with negative `inset` enlarges a small icon's hit area without changing its look.

## 8. Forms

Patterns in `forms-protocols.md`. The WCAG side:
- A visible label tied by `for` and `id` or by wrapping (1.3.1, 3.3.2). A placeholder
  is not a label. Required or optional shows in text, one convention per app
  (`forms-protocols.md` §1); required fields also carry `required`.
- Error identification (3.3.1): the message names field and problem, sits next to the
  field, is linked with `aria-describedby`; the field gets `aria-invalid="true"`.
- Error suggestion (3.3.3): say how to fix it (`wording-de.md` §7), for example
  „Geben Sie die Fläche als Zahl an, z. B. 12,5.“
- Long forms: an error summary at the top with links to the fields; focus moves there
  on submit.
- Input purpose (1.3.5): `autocomplete` on personal data (`name`, `email`, `tel`,
  `username`, `current-password`).
- Redundant entry (3.3.7): never ask again for data given earlier in the same
  process; prefill or offer it.
- Accessible authentication (3.3.8): allow paste and password managers, offer a show
  password toggle, no puzzle CAPTCHA.
- Error prevention (3.3.4): a submission with legal or financial effect (a signed
  Abnahmeprotokoll, an approval that triggers an order) can be reviewed, corrected or
  reversed before it is final.

## 9. Status messages and live regions

WCAG 4.1.3: a status message that does not take focus still reaches screen readers.
- `role="status"` (polite) for `Entwurf gespeichert`, sync status, import progress and
  result counts after filtering (`124 Aufträge`).
- `role="alert"` only for urgent errors such as `Senden fehlgeschlagen`. No extra
  `aria-live`.
- The region exists before its text changes. Change the text, do not insert the
  region.
- Throttle: import progress speaks per step or per quarter, not per percent.
- A status message never moves focus. A toast with an action is reachable by
  keyboard and stays until dismissed (2.2.1); see `states-feedback.md` §8.
- `aria-busy="true"` on a table region while it reloads, removed afterwards.

## 10. Pointer, drag and gestures

- Dragging (2.5.7): every drag has a single-pointer alternative. Reordering fields in
  the form builder offers „Nach oben“ and „Nach unten“ or a „Verschieben nach …“
  menu, plus keyboard access.
- Pointer gestures (2.5.1): pinch and path gestures have a simple alternative: zoom
  buttons for photos, a visible button for each swipe action. A signature pad is
  path-based by nature; offer a non-drawing alternative where the process allows
  (`forms-protocols.md` §9).
- Pointer cancellation (2.5.2): act on release (`click`), not on `pointerdown`.
  Moving away before release cancels. A press state on down is fine.
- Motion actuation (2.5.4): shaking or tilting is never the only trigger.
- Hover and focus content (1.4.13): a tooltip closes with Escape, can be hovered, and
  stays until pointer or focus leaves.

## 11. Text size, zoom and reflow

- Resize text (1.4.4): at 200 % zoom nothing is cut off or overlaps. Type in `rem`,
  no fixed `height` on text containers.
- Reflow (1.4.10): at 320 CSS px width the page does not scroll sideways. Data tables,
  maps and a signature canvas are exempt but scroll inside their own container.
- Text spacing (1.4.12): with these overrides nothing is clipped or overlaps.

```css
* { line-height: 1.5 !important; letter-spacing: 0.12em !important;
    word-spacing: 0.16em !important; }
p { margin-block-end: 2em !important; }
```

- Orientation (1.3.4): do not lock portrait; the Field app also works in landscape.
- Never block zoom: no `user-scalable=no`, no `maximum-scale=1`.

## 12. User preferences

- `prefers-reduced-motion: reduce`: movement becomes a short fade or nothing
  (`motion.md` §7).
- `forced-colors: active` (Windows contrast themes): borders, focus outlines, icons
  and status chips stay visible. SVG icons use `currentColor`. Meaning never lives in a
  `background-image` alone. Use `forced-color-adjust: none` only where you then set
  system colors such as `CanvasText` yourself.
- `prefers-contrast: more` may switch to a stronger token set. The Field app can
  offer an explicit high-contrast toggle (A).
- Dark is the default theme, light comes via `[data-theme="light"]`. Whether a first
  visit follows the system setting is a project decision (`tokens-theming.md` §5).

## 13. Images, icons and media

- Informative images: `alt` says what matters in the image. Decorative images:
  `alt=""`, no extra role.
- Icon-only buttons have a name: `aria-label="Position löschen"` or visually hidden
  text. Icons inside buttons or next to visible labels get `aria-hidden="true"`.
- Protocol photos take `alt` from their caption („Riss in der Bodenfliese, Bad OG“).
  Without a caption, prompt for one instead of guessing.
- A tenant logo has the company name as `alt`, read from the tenant config.
- Training videos have captions (1.2.2). Voice input shows its transcript as text
  (`field-use.md` §5).
- Nothing flashes more than three times per second (2.3.1).
