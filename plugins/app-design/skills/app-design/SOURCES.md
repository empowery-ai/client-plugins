# Sources

This skill is a rewrite. It uses material from four MIT-licensed projects, pinned to
one commit each. Nothing is pasted: every rule was rewritten in our own words and fitted
to three app profiles (Office tool, White-label core, Field app). This file records
where each section came from, what we left out, and how to check upstream for changes.
License texts and copyright notices: `NOTICE.md`.

## 1. Sources

| Id | Repository | Upstream path | Pinned commit | Commit date | License holder |
|---|---|---|---|---|---|
| S1 | https://github.com/B-Riemer/claude-skills | `skills/apple-design-pro/` | `d82cf8d7bd69e39f4cb849db3b853d3973b2d9c1` | 2026-10-22 | Copyright (c) 2026 BjorVik, MIT |
| S2 | https://github.com/szilu/ux-designer-skill | `/` (`SKILL.md`, `references/`) | `c869d32fd8df7bd7fcd1db68e93bd3e89eed5161` | 2026-09-28 | Copyright (c) 2026 Szilárd Hajba, MIT |
| S3 | https://github.com/wornysek/claude-web-skills-toolkit | `skills/ux-writing-de/` | `ca14fcfea8cde88f19114eae9a1e7fe824c90170` | 2026-11-01 | Copyright (c) 2026 claude-web-skills-toolkit contributors, MIT |
| S1-origin | https://github.com/emilkowalski/skills | `skills/apple-design/` | `c8a79627b59d72d764d6ab6f2c87c09a48169833` | 2026-11-04 | Copyright (c) 2026 Emil Kowalski, MIT |

Notes:
- S1's `references/motion-principles.md` is an adaptation of S1-origin `SKILL.md`, with
  the same section numbers (§1 to §17). Rows below that cite motion-principles name
  both: "S1 `references/motion-principles.md` §N = S1-origin `SKILL.md` §N".
  Rows with source `S1, S1-origin` and only a section number cite that shared section.
- Upstream file paths below are relative to the upstream path in the table above.
- `own` means no upstream source: our rule, written for the three profiles.
- Change: `adapted` keeps the upstream rule and changes examples, values or scope;
  `rewritten` keeps only the idea, in new words and structure; `new` has no upstream.

## 2. Mapping

### SKILL.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Pick the mode | S1 | `SKILL.md` Pick the mode | rewritten (three modes: Build, Review, Wording) |
| 2 Establish context | S1 | `SKILL.md` Review mode > Step 1: Establish context | adapted |
| 2 Establish context (profile table) | own | | new |
| 3 What to load | S1, S2 | S1 `SKILL.md` Reference files; S2 `SKILL.md` Reference routing | rewritten |
| 4 Core principles | S2 | `SKILL.md` Philosophy, Core rules | rewritten |
| 4 Core principles | S1 | `SKILL.md` Principles that apply to both modes | rewritten |
| 5 Build mode | S1, S2 | S1 `SKILL.md` Build mode; S2 `SKILL.md` Workflow: Building UI | rewritten |
| 6 Review mode | S1 | `SKILL.md` Review mode Steps 2 and 3, Severity | adapted |
| 7 Report format | S1 | `SKILL.md` Report format | adapted |
| 8 Wording mode | S3 | `SKILL.md` Process, Output format | adapted |
| 9 Evidence and citations | S1 | `SKILL.md` Rules for findings | adapted |
| 2, 6, 9 (64 px main control, report language, re-read cited lines) | own | | new |

### references/wording-de.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Process | S3 | `SKILL.md` Process (steps 1 to 5 and 7; step 6 dropped) | adapted |
| 2 Form of address | S3 | `SKILL.md` §1 Form of address | rewritten |
| 3 Inclusive language | S3 | `SKILL.md` §2 Gender-inclusive language | rewritten |
| 4 Tone | S3 | `SKILL.md` §7 Error messages (bitte, Hoppla, exclamation bullets) | rewritten |
| 4 Tone | S2 | `references/09-ux-writing.md` Core Principles (structure only) | rewritten |
| 5 Buttons and links | S3 | `SKILL.md` §5 Buttons and links (first block); §11 capitalization bullet | adapted |
| 6 Labels, hints, placeholders | S3 | `SKILL.md` §6 Forms | adapted |
| 7 Error messages | S3 | `SKILL.md` §7 Error messages (formula, table, reference code, no security leak) | rewritten |
| 7 Error messages | S2 | `references/09-ux-writing.md` Writing for Common UI Elements: Error Messages (structure only) | rewritten |
| 8 Empty states, confirmations, success | S3 | `SKILL.md` §8 Empty states, dialogs, success messages (email bullet dropped) | adapted |
| 9 Status vocabulary | own | | new |
| 10 Table and filter wording | own | | new |
| 11 Field and voice wording | S3 | `SKILL.md` §7 table, network row (seed only) | new |
| 12 Plain language | S3 | `SKILL.md` §13 Plain language (table, first bullet) | rewritten |
| 13 Glossary | S3 | `SKILL.md` §10 Glossary (generic entries); domain terms own | adapted |
| 14 Output format | S3 | `SKILL.md` Output format | adapted |

### references/formats-de.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Locale | S3 | `SKILL.md` §14 Regional variants; §11 regional notes on currency and dates | rewritten |
| 2 Numbers and currency | S3 | `SKILL.md` §11 Numbers, Currency | adapted |
| 2 Numbers and currency | S2 | `references/23-internationalization.md` Locale-Aware Formatting (NumberFormat) | adapted |
| 3 Parsing German input | own | | new |
| 4 Dates and times | S3 | `SKILL.md` §11 Dates, Times | adapted |
| 4 Dates and times | S2 | `references/23-internationalization.md` Locale-Aware Formatting (DateTimeFormat, RelativeTimeFormat); time zones row | adapted |
| 5 Units and percent | S3 | `SKILL.md` §11 Percent and units | adapted |
| 5 (no invented unit abbreviations) | own | | new |
| 6 Plurals | S3 | `SKILL.md` §4 Plurals | adapted |
| 7 Variables in text | S3 | `SKILL.md` §3 Inserted variables and grammar | rewritten |
| 7 Variables in text | S2 | `references/23-internationalization.md` Text Expansion & Contraction (never concatenate fragments) | adapted |
| 8 Typography | S3 | `SKILL.md` §11 German typography | adapted |
| 9 Long words and text expansion | S3 | `SKILL.md` §12 Long words and text expansion | adapted |
| 9 Long words and text expansion | S2 | `references/23-internationalization.md` Text Expansion & Contraction (no fixed widths, avoid truncation) | adapted |
| 10 Strings in code | S2 | `SKILL.md` Core rules (i18n); `references/23-internationalization.md` Translation-Friendly UI | adapted |
| 10 Strings in code | S3 | `SKILL.md` Behavior rules (message files, ICU) | adapted |

### references/accessibility.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Target and scope | S2 | `references/03-accessibility.md` WCAG 2.2 Overview, Legal Requirements | rewritten |
| 2 Semantics first | S1 | `references/web-lens.md` §3 (native elements) | rewritten |
| 2 Semantics first | S2 | `references/03-accessibility.md` Screen Reader Compatibility (wrong samples corrected) | rewritten |
| 3 Keyboard | S1 | `references/web-lens.md` §3 Interactive states and keyboard | adapted |
| 3 Keyboard | S2 | `references/03-accessibility.md` Keyboard Navigation | rewritten |
| 4 Focus | S1 | `references/web-lens.md` §1 (scroll-padding), §3 (focus-visible, 2.4.11) | adapted |
| 4 Focus | S2 | `references/03-accessibility.md` Focus Not Obscured 2.4.11, Focus Management | rewritten |
| 5 Dialogs, menus and overlays | S1 | `SKILL.md` Review mode > Step 2 (runtime check); `references/web-lens.md` §3 (overlays) | adapted |
| 5 Dialogs, menus and overlays | S1, S1-origin | S1 `references/motion-principles.md` §12 = S1-origin `SKILL.md` §12 (modal with scrim, one idea) | rewritten |
| 6 Contrast and color | S1 | `references/web-lens.md` §4 Color and contrast | adapted |
| 6 Contrast and color | S2 | `references/03-accessibility.md` Color and Contrast | rewritten |
| 7 Target size | S1 | `references/web-lens.md` §2 Touch and pointer | adapted |
| 7 Target size | S2 | `references/03-accessibility.md` Target Size (Minimum) 2.5.8, Touch Accessibility | rewritten |
| 8 Forms | S2 | `references/03-accessibility.md` Forms Accessibility, 3.3.7, 3.3.8 | rewritten |
| 8 Forms | S1 | `references/web-lens.md` §10 Forms | adapted |
| 9 Status messages and live regions | S2 | `references/03-accessibility.md` ARIA (live regions), Error Handling | rewritten |
| 10 Pointer, drag and gestures | S2 | `references/03-accessibility.md` Dragging Movements 2.5.7; `references/06-interaction-design.md` Gesture Design | rewritten |
| 11 Text size, zoom and reflow | S1 | `references/web-lens.md` §1 Responsiveness and layout | adapted |
| 12 User preferences | S1 | `references/web-lens.md` §4 last bullet, §9 Dark mode and user preferences | adapted |
| 12 User preferences | S1, S1-origin | S1 `references/motion-principles.md` §14 = S1-origin `SKILL.md` §14 (transparency dropped) | rewritten |
| 13 Images, icons and media | S1 | `references/web-lens.md` §7 (alt rule), §3 (icon-only names) | adapted |
| 13 Images, icons and media | S2 | `references/03-accessibility.md` Image Accessibility, Auto-Playing Content | rewritten |

### references/review-procedure.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Establish context | S1 | `SKILL.md` Review mode > Step 1 | adapted |
| 1 Establish context | S2 | `SKILL.md` Workflow: Reviewing or auditing a UI, step 1 | rewritten |
| 2 Evidence levels | S1 | `SKILL.md` Step 2: Measure, do not guess; Rules for findings | adapted |
| 3 Lens 1: Accessibility | S1 | `SKILL.md` Step 3, lens 1 | adapted |
| 3 Lens 1: Accessibility | S2 | `references/03-accessibility.md` Testing Checklist | rewritten |
| 4 Lens 2: Device and context fit | S1 | `SKILL.md` Step 3, lens 2 (web) | adapted |
| 5 Lens 3: States and data | S2 | `SKILL.md` Workflow: Reviewing step 2; Workflow: Building UI step 2 | rewritten |
| 6 Lens 4: Visual consistency and tokens | S1 | `SKILL.md` Step 3 lens 3; `references/visual-craft.md` §1 to §4 | adapted |
| 6 Lens 4: Visual consistency and tokens | S2 | `SKILL.md` Generated-UI defaults to avoid | rewritten |
| 7 Lens 5: Motion | S1 | `SKILL.md` Step 3, lens 4 (minimum checks) | adapted |
| 8 Lens 6: Wording | S1 | `SKILL.md` Step 3, lens 5 | adapted |
| 8 Lens 6: Wording | S3 | `SKILL.md` Process, Output format | adapted |
| 9 Heuristic cross-check | S2 | `references/01-core-principles.md` Nielsen's 10 Usability Heuristics (own one-line wording) | rewritten |
| 10 Extremes to test | S2 | `SKILL.md` Workflow: Reviewing, step 3 | adapted |
| 11 Severity | S1 | `SKILL.md` Severity (contradiction resolved, examples replaced) | adapted |
| 12 Rules for findings | S1 | `SKILL.md` Rules for findings; Principles that apply to both modes | adapted |
| 12 Rules for findings | S2 | `references/07-forms-and-inputs.md` evidence note; `SKILL.md` Reference values closing note | rewritten |
| 3, 5, 6, 8 (role match, expandable rows, emphasis, one meaning per word, developer terms) | own | | new |
| 12 (behavior from the function body, re-read cited lines) | own | | new |
| 13 (report language follows the request) | own | | new |
| 13 Report format | S1 | `SKILL.md` Report format | adapted |
| 13 Report format | S2 | `SKILL.md` Workflow: Reviewing step 4 (Blocker, Major, Minor mapped to our levels) | adapted |
| 14 After fixes | S1 | `SKILL.md` After fixes: re-measure | adapted |

### references/measuring.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Principles | S1 | `SKILL.md` Measurement script (test account); `README.md` Limits | rewritten |
| 2 Setup matrix | S1 | `scripts/measure.mjs` header comment | rewritten |
| 3 Horizontal overflow | S1 | `scripts/measure.mjs` overflow culprits; `references/web-lens.md` §1 | rewritten |
| 4 Target size | S1 | `scripts/measure.mjs` tap targets block and limitations | rewritten |
| 5 Contrast | S1 | `scripts/measure.mjs` DOM contrast; `references/web-lens.md` §4 | rewritten |
| 6 Type and color inventory | S1 | `scripts/measure.mjs` typography inventory; `references/visual-craft.md` §1, §3 | rewritten |
| 7 Keyboard pass | S1 | `scripts/measure.mjs` keyboard pass and focus limitations; `SKILL.md` Step 2 | rewritten |
| 8 Preferences pass | S1 | `scripts/measure.mjs` reduced-motion and preferences passes; `references/web-lens.md` §9 | rewritten |
| 9 Performance and stability | S1 | `scripts/measure.mjs` CLS, LCP, console, requests; `references/web-lens.md` §5, §6 | adapted |
| 10 Network and offline pass | own | | new |
| 11 Screen reader spot-check | S2 | `references/03-accessibility.md` Testing Checklist (screen readers) | rewritten |
| 12 Code-only and screenshot-only reviews | S1 | `SKILL.md` Step 2 (code only, screenshots only) | rewritten |
| 13 Optional automation | own | | new |
| 14 Recording results | S1 | `SKILL.md` After fixes: re-measure | rewritten |

### references/motion.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 When motion earns its place | S2 | `references/06-interaction-design.md` 2026 Trends: Functional Motion | rewritten |
| 1 When motion earns its place | S1 | `references/visual-craft.md` §4 Restraint | rewritten |
| 2 Press feedback | S1, S1-origin | S1 `references/motion-principles.md` §1 = S1-origin `SKILL.md` §1 Response | rewritten |
| 3 Durations and easing | S2 | `references/06-interaction-design.md` Animation Principles; `SKILL.md` Core rules (interaction) | rewritten |
| 4 Interruptibility | S1, S1-origin | §3 Interruptibility (no input lock, reverse from current value) | rewritten |
| 5 Enter and exit | S1, S1-origin | §7 Spatial consistency | rewritten |
| 6 Performance | S1, S1-origin | §11 Frame-level smoothness | rewritten |
| 6 Performance | S1 | `references/web-lens.md` §6 Layout shifts | adapted |
| 7 Reduced motion | S1, S1-origin | §14 Reduced motion and accessibility | rewritten |
| 7 Reduced motion | S2 | `references/06-interaction-design.md` Reduced Motion | rewritten |
| 8 What we do not do | own | | new |

### references/tokens-theming.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Token tiers | S2 | `references/11-design-systems.md` Design Tokens (Universal Language, Token Types, Semantic Tokens) | rewritten |
| 2 Names and file layout | S1 | `references/web-lens.md` §9 (tokens in one place) | rewritten |
| 2 Names and file layout (canonical names, load order) | own | | new |
| 3 Tenant brand layer | S1 | `references/visual-craft.md` §3 Color: one meaning per color | adapted |
| 4 Contrast guards per tenant | S1 | `references/web-lens.md` §4 (thresholds) | rewritten |
| 4 (worked cases, tenant checklist) | own | | new |
| 5 Dark default and light theme | S1 | `references/web-lens.md` §9 | adapted |
| 5 Dark default and light theme | S2 | `references/04-visual-design.md` Dark Mode Considerations | adapted |
| 6 Color discipline | S1 | `references/visual-craft.md` §3 | adapted |
| 6 Color discipline | S2 | `SKILL.md` Generated-UI defaults to avoid | adapted |
| 7 Typography | S1 | `references/visual-craft.md` §1 Typography hierarchy; `references/web-lens.md` §8 Fonts | adapted |
| 7 Typography | S1, S1-origin | §15 Typography (rem, leading) | adapted |
| 7 (size table, font CDN note) | own | | new |
| 8 Spacing, radius and density | S1 | `references/visual-craft.md` §2 Spacing rhythm | adapted |
| 8 Spacing, radius and density | S2 | `references/04-visual-design.md` Whitespace and Spacing | adapted |
| 8 (density via `--row-height`) | own | | new |
| 9 Motion and elevation tokens | own | | new |
| 10 Component states and variants | S2 | `references/11-design-systems.md` Component Architecture | adapted |
| 10 Component states and variants | S2 | `references/06-interaction-design.md` Feedback States (corrected) | rewritten |
| 11 Drift checks | S1 | `references/visual-craft.md` §1, §3 (count distinct values) | adapted |

### references/layout-navigation.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Profiles | S1 | `SKILL.md` Review mode Step 1 | rewritten |
| 1 (profile table, logo rule) | own | | new |
| 2 Structure and hierarchy | S1 | `references/visual-craft.md` §4 Restraint, §7 Checklist (three items) | adapted |
| 2 Structure and hierarchy | S2 | `SKILL.md` Generated-UI defaults to avoid | adapted |
| 2 (page skeletons) | own | | new |
| 3 Navigation and wayfinding | S2 | `references/05-information-architecture.md` Navigation Patterns, Labeling Best Practices, Common IA Mistakes | adapted |
| 3 Navigation and wayfinding | S2 | `references/08-mobile-ux.md` Mobile Navigation Patterns | adapted |
| 3 Navigation and wayfinding | S1, S1-origin | §16 tactical rules (wayfinding, specific labels) | rewritten |
| 4 Dialog, side panel, full page or bottom sheet | S2 | `SKILL.md` Decision trees: Modal vs. side panel vs. full page | adapted |
| 4 (phone variant, no dialog on dialog) | own | | new |
| 5 Responsive layout and reflow | S1 | `references/web-lens.md` §1 | adapted |
| 5 Responsive layout and reflow | S2 | `references/08-mobile-ux.md` Safe Areas, Mobile Forms (sticky submit) | adapted |
| 6 Applied UX laws | S2 | `references/02-laws-of-ux.md` Fitts, Hick, Tesler, Postel, Jakob, Miller | rewritten |
| 7 Layout stability | S1 | `references/web-lens.md` §6 Layout shifts | adapted |
| 7 Layout stability | S2 | `references/22-performance-ux.md` Content Layout Shift Prevention | adapted |

### references/tables-filters.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Table or list | S2 | `references/21-data-tables.md` Table Layout Patterns, Accessibility checklist | rewritten |
| 2 Density, alignment and numbers | S2 | `references/04-visual-design.md` Text Alignment; `references/21-data-tables.md` Table Toolbar, Key Metrics | adapted |
| 2 Density, alignment and numbers | S1 | `references/visual-craft.md` §1 (tabular figures) | adapted |
| 3 Sticky header and first column | S2 | `references/21-data-tables.md` Fixed Headers, Fixed Columns | rewritten |
| 3 Sticky header and first column | S1 | `references/web-lens.md` §1 (table reflow exception) | adapted |
| 3 Sticky header and first column | S1, S1-origin | §12 Materials and depth (one sentence: opaque sticky background) | rewritten |
| 4 Sorting | S2 | `references/21-data-tables.md` Sorting, Anti-Patterns | adapted |
| 4 (German collation, tie-break, URL state) | own | | new |
| 5 Filters and search | S2 | `references/19-search-ux.md` Search Box Design, Autocomplete, Faceted Search and Filters, Zero Results, Saved Searches | adapted |
| 5 Filters and search | S2 | `references/21-data-tables.md` Filtering | adapted |
| 5 (German normalization, article numbers, scanner Enter) | own | | new |
| 6 Pagination and virtual scrolling | S2 | `references/21-data-tables.md` Pagination vs. Infinite Scroll vs. Virtual Scrolling (corrected) | rewritten |
| 6 Pagination and virtual scrolling | S1 | `references/web-lens.md` §5 (INP) | adapted |
| 7 Selection and bulk actions | S2 | `references/21-data-tables.md` Bulk Selection and Actions | adapted |
| 8 Row actions, detail and inline edit | S2 | `references/21-data-tables.md` Row Expansion and Detail, Table Toolbar | adapted |
| 8 (aria-controls target, capped histories, open row under a filter) | own | | new |
| 9 Keyboard | S2 | `references/21-data-tables.md` Accessibility (keyboard), corrected | rewritten |
| 10 Table states | S2 | `references/21-data-tables.md` Empty States and Loading; `references/18-data-visualization.md` Empty and Error States | adapted |
| 11 Import status | S2 | `references/22-performance-ux.md` Progress Indicators (multi-step) | adapted |
| 11 (counts, error list, report, rerun) | own | | new |
| 12 Lists on the phone | S2 | `references/21-data-tables.md` Responsive Table Strategies (concept only) | rewritten |

### references/states-feedback.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 The state list | S2 | `SKILL.md` Workflow: Building UI (every state) | adapted |
| 2 Response times and indicators | S2 | `references/22-performance-ux.md` Perceived Performance, Loading Indicator Decision Tree | rewritten |
| 2 Response times and indicators | S1, S1-origin | §1 Response (latency) | rewritten |
| 3 Skeletons and spinners | S2 | `references/22-performance-ux.md` Skeleton Screens, Anti-Patterns | adapted |
| 4 Pending buttons and double submit | S2 | `references/22-performance-ux.md` Button Loading States (corrected) | rewritten |
| 4 Pending buttons and double submit | S1 | `references/web-lens.md` §10 Forms | adapted |
| 5 Progress for long jobs | S2 | `references/22-performance-ux.md` Progress Indicators | adapted |
| 6 Empty states | S2 | `references/16-onboarding.md` Empty States as Onboarding | rewritten |
| 7 Errors | S2 | `SKILL.md` Core rules (forms) | adapted |
| 7 Errors | S3 | `SKILL.md` §7 (structure only) | adapted |
| 7 (session expiry, reference code, error kinds) | own | | new |
| 8 Choosing inline, banner, toast or dialog | S2 | `SKILL.md` Decision trees: Notification type; `references/17-notifications.md` Severity and Visual Hierarchy, In-App Notifications | rewritten |
| 8 (canonical toast rule) | own | | new |
| 9 Destructive actions and undo | S1, S1-origin | §16 tactical rule Agency (undo over confirm) | rewritten |
| 10 Optimistic or pessimistic updates | S2 | `references/22-performance-ux.md` Optimistic Updates (corrected) | rewritten |
| 11 Stale and partial data | S2 | `references/18-data-visualization.md` Stale Data Indicators; `references/22-performance-ux.md` Offline-First and Cached State UX | adapted |

### references/forms-protocols.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Labels and layout | S1 | `references/web-lens.md` §10 Forms | rewritten |
| 1 Labels and layout | S2 | `references/07-forms-and-inputs.md` Form Design Principles, Labels and Placeholders, Required Fields, Form Layout | rewritten |
| 2 Input types | S2 | `references/07-forms-and-inputs.md` Input Types, Input Attributes, Autocomplete Values; `references/08-mobile-ux.md` Mobile Forms | adapted |
| 2 (decimals as text, option thresholds, enterkeyhint) | own | | new |
| 3 Validation | S2 | `references/07-forms-and-inputs.md` Validation | adapted |
| 3 Validation | S1 | `references/web-lens.md` §10 | adapted |
| 3 (submit stays enabled, summary or first field, warnings, 422 mapping) | own | | new |
| 4 Submit and pending | S1 | `references/web-lens.md` §10 | adapted |
| 4 Submit and pending | S2 | `references/07-forms-and-inputs.md` Submit Buttons | rewritten |
| 5 Long protocols | S2 | `references/07-forms-and-inputs.md` Multi-Step Forms | rewritten |
| 5 (section list, per-section save, review view, resume) | own | | new |
| 6 Autosave and drafts | S2 | `references/12b-conflict-resolution-sync.md` Offline & Sync (concept) | rewritten |
| 6 (debounce, restore, schema version, camera reload) | own | | new |
| 7 Defaults and redundant entry | S2 | `references/03-accessibility.md` Redundant Entry 3.3.7 | adapted |
| 7 (prefill from order, carry over) | own | | new |
| 8 Photo fields | own | | new |
| 9 Signature field | S2 | `references/03-accessibility.md` Dragging Movements 2.5.7 (context) | adapted |
| 9 Signature field | S1, S1-origin | §10 Gesture design details (commit on release) | adapted |
| 9 (pad, printed name, lock, alternative) | own | | new |
| 10 Forms from a form builder | own | | new |
| 10 (non-drag alternative) | S2 | `references/03-accessibility.md` Dragging Movements 2.5.7 | adapted |
| 11 Edit conflicts | S2 | `references/12b-conflict-resolution-sync.md` Merge Conflict UI | adapted |
| 12 Login | S2 | `references/03-accessibility.md` Accessible Authentication 3.3.8; `references/07-forms-and-inputs.md` Password Fields (show and hide only) | adapted |
| 12 Login | S1 | `references/web-lens.md` §10 (allow paste) | adapted |
| 12 (no security detail, session expiry keeps draft) | own | | new |

### references/field-use.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 Field conditions | S2 | `references/25b-barcode-scanner-workflows.md` Screen Design for the Floor; Devices | rewritten |
| 1 Field conditions | S1, S1-origin | §17 Process (test in the real context, one line) | adapted |
| 2 Touch targets and the thumb | S1 | `references/web-lens.md` §2 Touch and pointer | adapted |
| 2 Touch targets and the thumb | S2 | `references/08-mobile-ux.md` Thumb Zone, Touch Target Sizes, Responsive Gestures; `references/06-interaction-design.md` Gesture Design | rewritten |
| 2 Touch targets and the thumb | S1, S1-origin | §10 Gesture design details (commit on release) | adapted |
| 2 (glove sizes, 64 px main control, gaps, destructive spacing, list rows) | own | | new |
| 3 Sunlight and readability | S2 | `references/25b-barcode-scanner-workflows.md` Screen Design for the Floor | adapted |
| 3 (7:1 rule, weights, light theme option, test method) | own | | new |
| 4 Phone layout and the on-screen keyboard | S2 | `references/08-mobile-ux.md` Mobile Forms, Safe Areas | adapted |
| 4 Phone layout and the on-screen keyboard | S1 | `references/web-lens.md` §1, §2 | adapted |
| 4 (visualViewport, overscroll-behavior, scroll-padding-bottom) | own | | new |
| 5 Voice input | S2 | `references/24-voice-and-multimodal.md` Voice as a First-Class Input, Activation, Privacy, Accessibility Intersection, Recognition feedback | rewritten |
| 5 (editable lines, catalog matching, level indicator, offline at the mic, data flow) | own | | new |
| 6 Camera and photos | S2 | `references/25a-barcode-camera-scanning.md` Camera Permission, Web Specifics | adapted |
| 6 (file input default, resize, orientation, thumbnail, memory) | own | | new |
| 7 Camera scanning | S2 | `references/25a-barcode-camera-scanning.md` When to Offer Scanning, The Viewfinder, Live States & Guidance, Hard Conditions, After the Scan, Scanning from an Image, Accessibility, Web Specifics | rewritten |
| 7 Camera scanning | S2 | `references/25c-barcode-display.md` (one line: human-readable number on labels) | rewritten |
| 8 Hardware scanners | S2 | `references/25b-barcode-scanner-workflows.md` Scan-First Design, Input Capture, Scan Routing, Error Recovery, Batch Counters & Undo, Manual Entry Fallback & Audit | rewritten |
| 8 (German examples, error table, check digits) | own | | new |
| 9 Feedback when eyes are busy | S2 | `references/25a-barcode-camera-scanning.md` Feedback; `references/25b-barcode-scanner-workflows.md` Eyes-Free Feedback | adapted |
| 10 Testing in the field | S2 | `references/08-mobile-ux.md` Testing Checklist | rewritten |
| 10 Testing in the field | S1, S1-origin | §17 Process | adapted |

### references/offline-sync.md

| § | Source | Upstream file, section | Change |
|---|---|---|---|
| 1 What works offline | S2 | `references/22-performance-ux.md` Offline-First & Cached State UX | adapted |
| 1 (approvals need the server, cache scope, queue rule) | own | | new |
| 2 Connection and sync status | S2 | `references/12b-conflict-resolution-sync.md` Offline & Sync; `references/22-performance-ux.md` Offline-First & Cached State UX | adapted |
| 2 (onLine as hint, probe, banner timing, sign-out with pending items) | own | | new |
| 3 The outbox | S2 | `references/12b-conflict-resolution-sync.md` Offline & Sync (sync queue) | rewritten |
| 3 (IndexedDB, item fields, persist and estimate, photo budget) | own | | new |
| 4 Retries and idempotency | S2 | `references/25b-barcode-scanner-workflows.md` Offline, Retries & Idempotency; `references/12b-conflict-resolution-sync.md` Key Metrics (backoff) | adapted |
| 4 (jitter formula, status code table) | own | | new |
| 5 Browser limits | own | | new |
| 6 Conflicts | S2 | `references/12b-conflict-resolution-sync.md` Merge Conflict UI; `references/25b-barcode-scanner-workflows.md` Offline, Retries & Idempotency | adapted |
| 7 Uploads on a weak network | S1 | `references/web-lens.md` §5 (weak network framing) | adapted |
| 7 (chunks, per-file progress, app-level upload manager) | own | | new |
| 8 Testing offline | own | | new |

## 3. What we dropped and why

Plugin rules:
- S1 `scripts/measure.mjs`, its CLI flags (`--state`, `--skip`, `--schemes`, `--shots`),
  the Playwright install hint and its summary file. Client plugins may not ship
  scripts or executables, and the skill must also work without a shell. We replaced
  the script with a written procedure in `references/measuring.md` that works with
  DevTools, axe, Lighthouse, an existing Playwright setup, or by hand.
- S1 `SKILL.md` "Measurement script" section, for the same reason.

Brand and copying rules:
- The upstream names of S1 and S1-origin and every vendor brand reference: our skill
  has its own name and cites WCAG 2.2, Nielsen and the WAI-ARIA Authoring Practices.
- S1 `references/hig-links.md` (a list of vendor guideline links) and S1 `SKILL.md`
  "Do not cargo-cult" note.
- S1-origin "Initial Response" and "The Core Idea" sections, all quotes from vendor
  design talks, and the Quick Reference table.
- S2 `references/02-laws-of-ux.md` blockquoted law statements; S2
  `references/01-core-principles.md` heuristic wording (we wrote one line each).

Out of scope for our apps:
- Marketing and landing pages: S3 `SKILL.md` §9; S1 `references/visual-craft.md` §5
  signature element and §6 template look; S1 marketing severity examples (hero image,
  conversion); S1 `references/web-lens.md` §5 LCP and hero image detail, §7 image
  formats and video.
- E-commerce: S3 `SKILL.md` §5 legal block (§ 312j and § 312k BGB); S2
  `references/07-forms-and-inputs.md` credit card, US address, US phone and date
  patterns, Baymard figures; S2 `references/19-search-ux.md` shop facets, ratings,
  swatches; all payment, newsletter and subscription examples.
- Native code and physics: S1-origin and S1 `references/motion-principles.md` §2, §4,
  §5, §6, §8, §9, §10 (except commit on release), §12 (except one legibility idea),
  §13; springs, velocity, momentum, rubber-banding, haptics and sound; S2
  `references/25a-barcode-camera-scanning.md` native SDKs and platform permission
  detail; S2 `references/25b-barcode-scanner-workflows.md` vendor device settings.
- Canvas, AI chat, collaboration and research: S2 `references/13a-canvas-navigation.md`,
  `13b-canvas-objects-performance.md`, `14-ai-ux-patterns.md`,
  `12a-presence-awareness.md`, `10-user-research.md`, `15-ethical-design.md`,
  `20-emotional-design.md`; S2 `references/12b-conflict-resolution-sync.md` OT, CRDT,
  locking, multiplayer undo, version history, sharing dialogs.
- Consumer patterns: S2 `references/16-onboarding.md` tours and activation; S2
  `references/17-notifications.md` push, email, notification center, permission
  prompts; S2 `references/08-mobile-ux.md` FAB, hamburger markup, foldables,
  pull-to-refresh, ripple; S2 `references/24-voice-and-multimodal.md` wake words,
  watch, TV, car, AR, handoff; S3 `SKILL.md` §8 email bullet.
- Other languages and regions: S2 `references/23-internationalization.md` RTL, bidi,
  logical properties, ICU gender, name order, global addresses and phones, calendars,
  pseudo-localization, language switcher, translator workflow; S2 `SKILL.md`
  `dir="rtl"` extreme; S3 `SKILL.md` §14 long Swiss and Austrian detail; S2
  `references/03-accessibility.md` US, UK, Canadian and Australian law.
- Public sector rules: S3 `SKILL.md` §13 Leichte Sprache and BITV 2.0.
- Skills we do not ship: S3 Process step 6 (deslop-de) and the related-skills lists.

Wrong, unsourced or in conflict with our rules:
- S2 samples with errors: `role="alert"` plus `aria-live="assertive"`, `aria-hidden` on
  a menu, `div tabindex role=button`, `role="presentation"` plus `alt=""`, empty CSS
  for 2.4.11, `role="grid"` on a plain table, emoji action buttons, hard-coded hex
  colors, `z-index: 9999`, an undefined `--color-white`. Correct rules were written
  instead.
- S2 `references/07-forms-and-inputs.md` disabled submit until valid, `role="alert"`
  per field, `type="number"` for numbers: replaced by `forms-protocols.md` §2 and §3.
- S2 `references/09-ux-writing.md` "do not embed variables mid-sentence": contradicts
  S2 `references/23-internationalization.md`; `formats-de.md` §7 decides.
- S2 `references/21-data-tables.md` column resizing (no keyboard alternative), card
  reflow CSS, infinite scroll for work lists, "max 7 to 10 columns".
- S2 global reduced-motion override (`0.01ms !important` on everything), bounce
  easing, 500 ms durations; S2 FID metric (retired, replaced by INP).
- S1 `SKILL.md` severity contradiction between "text below 3:1" and "body text under
  4.5:1": resolved in `review-procedure.md` §11.
- S1 default widths 320, 390, 1440: replaced by profile widths.
- Unsourced numbers: S2 thumb-zone percentages, mobile traffic share, color-blindness
  prevalence, conversion figures; S3 claim that German is 30 to 35 % longer (kept as
  a planning hint without a figure); S1-origin 0.2 Hz oscillation claim; S3 citations
  we could not verify (Rat für deutsche Rechtschreibung 2023, screen reader
  preferences of blind associations).
- House style: S3 spaced en dash as a sentence dash and DIN 5008 space grouping as an
  equal option; S2 humor in UI text.
- S1 pixel contrast method (needs a script) reduced to one sentence; S1 no-JavaScript
  and hidden-content passes (our apps are single-page apps behind a login); S1
  translucent layer checks and reduced transparency (we use no glass or blur).

## 4. Update check

Clone each source once, then fetch and list commits since our pin that touch the
path we used. The license file is in the path list, so a license change shows up too.

```sh
git clone https://github.com/B-Riemer/claude-skills ~/upstream/s1
git clone https://github.com/szilu/ux-designer-skill ~/upstream/s2
git clone https://github.com/wornysek/claude-web-skills-toolkit ~/upstream/s3
git clone https://github.com/emilkowalski/skills ~/upstream/s1-origin
for d in s1 s2 s3 s1-origin; do git -C ~/upstream/$d fetch origin; done
```

One command per source:

```sh
git -C ~/upstream/s1 log --oneline d82cf8d7bd69e39f4cb849db3b853d3973b2d9c1..origin/HEAD -- skills/apple-design-pro LICENSE
git -C ~/upstream/s2 log --oneline c869d32fd8df7bd7fcd1db68e93bd3e89eed5161..origin/HEAD -- SKILL.md references LICENSE
git -C ~/upstream/s3 log --oneline ca14fcfea8cde88f19114eae9a1e7fe824c90170..origin/HEAD -- skills/ux-writing-de LICENSE
git -C ~/upstream/s1-origin log --oneline c8a79627b59d72d764d6ab6f2c87c09a48169833..origin/HEAD -- skills/apple-design LICENSE
```

To read a change, replace `log --oneline` with `diff` in the same command.

Rule for taking an upstream change:
1. License change: stop and check before anything else.
2. Take it when it fixes a fact we also state (a WCAG number, a browser fact, a wrong
   code sample), or adds a rule that fits a profile and is in scope (section 3 lists
   what is not).
3. Skip it when it is rewording only, is in a dropped area, or conflicts with the
   canonical values our files share (target sizes, contrast, type sizes, durations,
   toast rule, severity).
4. Never paste. Rewrite in our words, place it in the section the mapping names, keep
   section numbers stable, then update the pinned commit, date and mapping rows here.
