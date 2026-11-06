# Layout and navigation

How a screen is structured and how users move between screens, for the three profiles.

Load when: building a new screen, choosing between dialog, side panel and page, setting up navigation, making a layout responsive, or reviewing page structure.

Contents: 1 Profiles, 2 Structure and hierarchy, 3 Navigation and wayfinding, 4 Dialog, side panel, full page or bottom sheet, 5 Responsive layout and reflow, 6 Applied UX laws, 7 Layout stability.

## 1. Profiles

Pick the profile first. It sets widths, input, density and the floor for targets. Values marked (A) are our assessment, not a standard.

| Profile | Device and input | Widths to test | Density and targets | Navigation |
|---|---|---|---|---|
| Office tool | Desktop browser, mouse and keyboard, office staff | 1280, 1440, 1920; 320 reflow and 200 % zoom | Rows 32, 40 or 48 px; targets 24 px floor, 32 px buttons (A) | Sidebar, breadcrumbs, split views |
| White-label core | Host profile, one design base, many tenants | As host profile, per tenant palette | As host profile | As host profile; tenant logo and name in the header |
| Field app | Phone, one hand, gloves, sunlight, weak network | 360, 390, 414 portrait, one landscape | Rows at least 56 px; targets 44, 48 with gloves, 56 primary, 64 main control (A) | Bottom bar, one task per screen |

- A screen declares its profile in the review scope. A table built for the Office tool is not shipped to the Field app unchanged (`tables-filters.md` §12).
- White-label core adds one rule: layout never depends on a tenant's logo size or name length. Reserve a box for the logo (max height, `object-fit: contain`) and let long tenant names wrap or truncate with the full name reachable.

## 2. Structure and hierarchy

- One primary action per screen. It has the strongest visual weight and sits where the user finishes the task: bottom of a form, top right of a list toolbar, bottom of the screen on a phone. Secondary actions are visibly weaker. Two filled buttons of equal weight in one toolbar is a finding.
- Removal test: if you delete an element and nobody would miss it, it was decoration. Remove it.
- Group by space and type weight before borders and cards. A card inside a card inside a card is a flag. One level of container is usually enough.
- Section order follows the task, not the database: what the user decides first comes first (customer, then items, then delivery).
- Page header: title (`h1`), status badge, one primary action, then secondary actions in a menu. The title names the object (`Auftrag 4711`), not the screen type.
- Three things that look like polish and are noise: icons that repeat the word next to them, a second and third button competing with the primary one, borders where whitespace would group as well.
- No hover-only actions. Every action reachable by hover is also reachable by keyboard focus and by touch (`accessibility.md` §3).
- No marketing patterns in app screens: hero blocks, testimonial rows, centered sections of equal padding. Show the data first.
- Check: squint at the screen or reduce it to a gray-scale screenshot. Can you tell what the main action and the main content are within two seconds?

Page skeletons to start from:

| Screen | Order, top to bottom |
|---|---|
| List (Office tool) | Page title and primary action, filter bar with result count, table, pagination |
| Detail (Office tool) | Title with status badge and primary action, key facts block, tabs or sections for positions, history, files |
| Form page | Title, section list, fields in one column, sticky action bar with `Speichern` and `Abbrechen` |
| Task screen (Field app) | Header with back and object name, one task, content, sticky bottom action bar with the one primary action |

- Wide screens: cap running text and forms at a readable width (about 70 characters, `max-width: 70ch`). Tables may use the full width. Do not stretch a form across 1920 px.
- Left-align labels and content. Center only short text such as an empty state message.

## 3. Navigation and wayfinding

Every screen answers four questions: where am I, where can I go, what is here, how do I leave. No dead ends.

Office tool and White-label core:
- A left sidebar for six or more destinations, a top bar for tenant logo, search and user menu. Keep the top level short enough to scan at a glance and group rare items (A; no fixed cap, see Miller in §6). Do not hide primary navigation behind a hamburger on desktop.
- Items are nouns that name the content: `Aufträge`, `Lieferscheine`, `Importläufe`, `Artikel`. Not `Übersicht`, `Start`, `Center`. Same word in the menu, the page title and the browser tab title.
- The current item has a visible state and `aria-current="page"`. The state has a second cue besides color (bar, bold).
- Breadcrumbs when the hierarchy is three or more levels deep (`Aufträge / Auftrag 4711 / Position 3`). They show the path, not the history. Each crumb is a link, the last one is plain text with `aria-current="page"`.
- Group by what users do, not by how the firm is organized. Depth beyond three levels is a signal to restructure (A).
- Leaving a form with unsaved input: autosave, or a confirm that names the loss (`forms-protocols.md` §6, `states-feedback.md` §9).
- Browser back and forward work. A filter, a sort, an open detail panel and a page number are part of the URL (`tables-filters.md` §5).

Field app:
- A bottom bar with three to five items, each with icon and text label. The tap target is the whole item, at least 48 px high. No icon-only items.
- No hamburger menu for primary destinations. A menu may hold rare things (`Einstellungen`, `Abmelden`).
- One task per screen. A back control is always visible at the top left or in the bottom bar. The user never needs the browser's back button.
- A sticky submit bar and a floating button do not share the bottom edge. Choose the sticky bar.
- The current protocol or order is shown in the header (`Montageprotokoll 2026-0412`) so a user returning after a phone call knows where they are.

## 4. Dialog, side panel, full page or bottom sheet

| Situation | Office tool and White-label core | Field app |
|---|---|---|
| Confirm one decision, or one to three fields (rename, reason for rejection) | Dialog | Bottom sheet |
| Look at or edit details while the list stays visible (order detail, row properties) | Side panel, right, 400 to 560 px | Full page |
| Edit that needs width (compare two versions, many fields) | Full page, with back | Full page |
| Short multi-step task, steps of one or two fields | Dialog with step counter | Full page per step |
| Long or complex work (a protocol, a delivery note with positions) | Full page | Full page, section list (`forms-protocols.md` §5) |
| A choice from a long list on a phone | Select or combobox | Full page list with search |

Rules:
- Never a dialog on top of a dialog. If a dialog needs another decision, replace its content or move the task to a page.
- A dialog is for a decision, not for information. Information goes into a banner, toast or inline (`states-feedback.md` §8).
- Long protocols are full pages with their own URL. A form that scrolls inside a dialog is a finding.
- A side panel does not hide the thing it explains: keep the selected row visible and highlighted. Escape closes it, focus returns to the row that opened it.
- Dialogs use native `dialog` with `showModal()`, a visible close control, a title, and the safe button focused first when the action is destructive (`accessibility.md` §5).
- A bottom sheet has a visible grab handle or close button. It is never the only way to reach an action (no swipe-only).
- Dialogs, side panels and bottom sheets open and close in 200 to 300 ms (`motion.md` §3).
- Reserve the side panel width while content loads. If the panel blocks the page behind it, treat it as a dialog: scrim, focus trap, Escape.
- A dialog has one primary button, right aligned on desktop and full width at the bottom on a phone. Its text repeats the action (`Auftrag freigeben`, `Abbrechen`), see `wording-de.md` §5.

## 5. Responsive layout and reflow

- Breakpoints come from where the content breaks, not from device names. Test widths are in the profile table (§1).
- 320 CSS px wide: no horizontal page scroll (WCAG 1.4.10). The exception is content that is two-dimensional by nature, for example a data table. Scroll inside the table container, not the page (`tables-filters.md` §3).
- 200 percent zoom: nothing clipped, no overlap, no lost function (WCAG 1.4.4). Use `rem` and `min-height`.
- Never block zoom: no `user-scalable=no`, no restrictive `maximum-scale` in the viewport meta tag.
- Do not lock orientation unless the task needs it (WCAG 1.3.4). Field app landscape is a supported case: the bottom bar stays, the content widens.
- Full-height mobile sections use `100dvh` or `svh`, not `100vh`. The browser toolbar changes what `100vh` covers.
- Devices with a notch or home bar: `viewport-fit=cover` plus `env(safe-area-inset-bottom)` padding on sticky bars.

```css
.action-bar { position: sticky; bottom: 0; padding: var(--space-3) var(--space-4);
  padding-bottom: calc(var(--space-3) + env(safe-area-inset-bottom)); background: var(--color-surface); }
html { scroll-padding-top: var(--header-height); }
```

- Sticky headers can cover the focused element or an anchor target. `scroll-padding-top` equal to the header height fixes both (WCAG 2.4.11).
- Long words and URLs: `overflow-wrap: anywhere` in narrow containers (`formats-de.md` §9).
- A list and detail layout collapses to one column on narrow screens: the list first, the detail as its own page with a back link. Do not squeeze both side by side below about 900 px (A).
- Toolbars wrap onto a second line instead of clipping. Overflow actions move into a `Mehr` menu with a text label, not an unlabeled icon.
- Field app, on-screen keyboard: see `field-use.md` §4.
- Check: DevTools device toolbar at each profile width, then 200 percent browser zoom, then 320 px.

## 6. Applied UX laws

One line each, in our terms. Use them to explain a finding, not as the finding itself.

- Fitts: time to hit a target depends on its size and distance. Make primary actions large and near the thumb, especially with gloves. Place the submit where the hand already is.
- Hick: more choices take longer. Show the three or four filters people use daily, put the rest behind `Weitere Filter`. Preselect sensible defaults.
- Tesler: complexity does not vanish, it moves. Let the system carry it: an import that matches columns itself, a form that prefills from the order, instead of asking the user to do it.
- Postel: be generous in what you accept. Accept an article number with spaces, dashes or dots, a decimal with a comma or a dot, a date as `6.11.` or `06.11.2026` (`formats-de.md` §3).
- Miller correction: the old seven-items rule is about memory, not menus. Menus are scanned. Size a list by how scannable it is, not by a cap of seven.
- Jakob: users expect your app to work like the others they use daily. Keep the standard places for search, user menu and save.

## 7. Layout stability

Content that jumps while users read or aim is a defect, most of all on a phone.

- Reserve space before content arrives: images get `width` and `height` or `aspect-ratio`. Table skeleton rows have the real row height. A badge that loads late has a placeholder of the same size.
- Do not insert banners above content the user is reading. Give banners a reserved slot or overlay them (`states-feedback.md` §8).
- Pending buttons keep their width: set `min-width`, change the label inside it (`states-feedback.md` §4).
- `scrollbar-gutter: stable` on scroll containers stops the layout from shifting when a scrollbar appears (browser feature, as of 2026-11, re-check support).
- Web fonts: self-hosted, `font-display: swap`, and a fallback with similar metrics so text does not reflow (`tokens-theming.md` §7).
- Animate `transform` and `opacity`, never `height`, `width`, `top` or `margin` (`motion.md` §6).
- Targets: Cumulative Layout Shift 0.1 or less, field data at the 75th percentile (web.dev, as of 2026-11). Check with the Performance panel's layout shift track or the layout shift regions highlight (`measuring.md` §9).
