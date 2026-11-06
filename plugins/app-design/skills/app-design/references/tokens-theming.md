# Tokens and theming

How color, type, space, motion and themes are defined once and changed per tenant.
Components read tokens and never raw values. A tenant changes a few tokens and nothing else.

Load when: building or reviewing any styled component, adding a tenant, adding or changing a theme, picking a font size, a spacing value or a row height.

Contents: 1 Token tiers, 2 Names and file layout, 3 Tenant brand layer, 4 Contrast guards per tenant, 5 Dark default and light theme, 6 Color discipline, 7 Typography, 8 Spacing, radius and density, 9 Motion and elevation tokens, 10 Component states and variants, 11 Drift checks.

## 1. Token tiers

Three tiers. Each tier may only read the tier above it.

1. Primitives: raw values with a scale name (`--gray-900`, `--blue-500`). They live only in the token file.
2. Semantic tokens: what a value is for (`--color-bg`, `--color-accent`, `--color-danger`). Components use these.
3. Component tokens: optional, for one component that needs its own knob (`--btn-bg`). They point at semantic tokens.

```css
:root {
  --gray-900: #14171c;          /* tier 1, token file only */
  --blue-400: #5aa2ff;
  --color-bg: var(--gray-900);  /* tier 2, used in components */
  --color-accent: var(--blue-400);
}
.btn-primary { --btn-bg: var(--color-accent); background: var(--btn-bg); }
```

Rules:
- A component never reads a primitive. Check: `grep -rn "var(--gray\|var(--blue" src` outside the token file returns nothing.
- Every `var(--x)` resolves to a defined token. An undefined reference (for example `--color-white` used but never declared) renders as nothing and fails silently. Check by searching each used name in the token file.
- A semantic token is added to the token file, never invented inside a component.
- Name by purpose, not by look: `--color-danger`, not `--color-red`. The value of a name may change per theme and tenant, the name never does.

## 2. Names and file layout

Canonical names. Other reference files use exactly these.

| Group | Tokens |
|---|---|
| Surface and text | `--color-bg`, `--color-surface`, `--color-surface-raised`, `--color-text`, `--color-text-muted`, `--color-border` |
| Brand and focus | `--color-accent`, `--color-accent-hover`, `--color-on-accent`, `--color-focus` |
| Status | `--color-success`, `--color-warning`, `--color-danger`, `--color-info`, each with an optional `-bg` variant for tinted backgrounds |
| Space | `--space-1` to `--space-7` (4, 8, 12, 16, 24, 32, 48 px) |
| Shape | `--radius-sm`, `--radius-md`, `--radius-lg` |
| Type | `--font-family-base`, `--font-size-xs` to `--font-size-xl` |
| Density | `--row-height` |
| Motion | `--duration-fast`, `--duration-base`, `--duration-slow`, `--ease-out`, `--ease-in` |

One optional extension: `--color-accent-text`, the accent step used for text and thin lines when the brand color is too light or too dark for that (see §4). Components that draw accent text read it and fall back to `--color-accent`.

File layout, one place per concern:

```
styles/tokens.css   primitives and semantic tokens, dark default in :root, light in [data-theme="light"]
styles/tenant.css   brand overrides, loaded after tokens.css, one block per theme
components/*.css    only var(--token), no raw values
```

Load order is part of the contract. `:root` and `[data-theme="light"]` have the same specificity, so the later rule wins. That is why the tenant file must set both themes explicitly and why it loads last. Check: swap the load order in DevTools and see the tenant accent disappear in one theme.

## 3. Tenant brand layer

White-label core: one design base, one brand layer per tenant.

A tenant may override:
- `--color-accent`, `--color-accent-hover`, `--color-on-accent`, and optionally `--color-accent-text`
- the logo (an `img` or inline SVG with a light and a dark variant)
- optionally `--font-family-base`, with one self-hosted font (§7)

A tenant may not override:
- status colors (`--color-success`, `--color-warning`, `--color-danger`, `--color-info`): users read them as signals
- `--color-focus`, spacing, radius, row height, durations
- text and surface colors, unless the product explicitly offers a themed background

Brand red must never double as danger red. If a tenant's brand is red, keep the accent for buttons and navigation and keep `--color-danger` distinct in hue and always paired with an icon or the word `Fehler`. Check by showing a primary button next to an error banner: they must not look related.

```css
/* tenant.css, generated from tenant config */
:root { --color-accent: #5aa2ff; --color-accent-hover: #86bcff; --color-on-accent: #0b1220; }
[data-theme="light"] { --color-accent: #1a5fc8; --color-accent-hover: #164fa5; --color-on-accent: #ffffff; }
```

## 4. Contrast guards per tenant

A brand color is chosen for a logo, not for a screen. It must be checked in each theme as three different things: a fill behind text, a line or icon, and text itself.

| Use of the accent | Pair to test | Needs | Source |
|---|---|---|---|
| Filled button, label inside | `--color-on-accent` on `--color-accent` | 4.5:1 | WCAG 1.4.3 |
| Selected tab line, switch, checkbox fill, icon that carries meaning | `--color-accent` on `--color-surface` and on `--color-bg` | 3:1 | WCAG 1.4.11 |
| Link or accent text | `--color-accent-text` on `--color-surface` | 4.5:1 | WCAG 1.4.3 |
| Focus ring | `--color-focus` on every neighbor | 3:1 | WCAG 1.4.11, 2.4.11 |

Worked cases (computed, as of 2026-11): a yellow brand color is about 1.6:1 against a white surface, so it fails as text and as a line in the light theme. It works as a fill with dark text on it (about 10:1). A dark navy brand color is about 1.5:1 against a dark surface, so it vanishes as a line in the dark theme. A brand red can pass in light (about 5.2:1 on white) and fail in dark (about 3.2:1 as text on a dark surface).

When a brand color fails, do this in order:
1. Keep the brand color for large areas (header, logo, buttons with a proper `--color-on-accent`).
2. Set `--color-accent-text` and the line color to a darker step in light and a lighter step in dark.
3. Do not accept a failing pair because the brand wants it. The table is the floor.

Checklist for adding a tenant:
1. Collect brand colors, logo (light and dark variant), optional font file.
2. Set accent, hover, on-accent for dark and light in `tenant.css`.
3. Test the three uses in the table above in both themes. Write the measured ratios into the tenant's notes.
4. Check the logo on `--color-bg` and `--color-surface` in both themes.
5. Open the five core screens (list, detail, form, dialog, empty state) in both themes and look.
6. Test the darkest and lightest accent of all tenants whenever a shared component changes.

## 5. Dark default and light theme

- Dark is the default: `:root` holds the dark values and `color-scheme: dark`. Light is `[data-theme="light"]` on `html` with `color-scheme: light`. `color-scheme` makes native controls and scrollbars follow the theme.
- Set the attribute before first paint, or users see a dark flash before a light theme. A tiny inline script in `head`, before the stylesheet:

```html
<script>
  try { var t = localStorage.getItem("theme"); if (t === "light") document.documentElement.dataset.theme = "light"; } catch (e) {}
</script>
```

- Persist the choice per user (account setting, or `localStorage` as a convenience). Wrap storage in try/catch: it can throw in private windows.
- Whether the first visit follows `prefers-color-scheme` is a project decision. Record it. Do not mix both silently.
- Dark is not an inverted light. Re-check every pair. Avoid pure white text on pure black: use a soft off-white for `--color-text` and a dark gray, not black, for `--color-bg`.
- Elevation in dark is carried by lighter surfaces: `--color-bg` < `--color-surface` < `--color-surface-raised`. Shadows are barely visible on dark, so a raised layer also gets a 1 px `--color-border`.
- Example token values (computed, as of 2026-11): dark text `#e8eaed` on bg `#14171c` is about 15:1, muted `#a3abb7` about 7.8:1, border `#6b7480` about 3.5:1. Light text `#1a1d23` on `#ffffff` is about 17:1, muted `#4b5563` about 7.6:1, border `#7a838f` about 3.8:1.
- Both themes need the status colors re-tuned: a green that passes on white is often too dark on a dark surface.
- Logos and icons need a dark and a light variant, or a safe plate behind them.
- Check both themes, every tenant palette, and the forced-colors case (`accessibility.md` §12).

## 6. Color discipline

- Neutral base, one accent, four semantic colors. Count the palette: list the distinct text and background colors in use. More than the tokens above means drift.
- The accent marks the primary action and the current state. If it also colors headings, icons, borders and backgrounds, it signals nothing.
- Each semantic color has one meaning only: danger red for errors and destructive actions, green for success, amber for warnings, blue for information.
- Status is never color alone. A badge always has its word (`Freigegeben`, `Abgelehnt`) or an icon with an accessible name; the color is extra (WCAG 1.4.1).
- Avoid the generated-UI look: purple or indigo gradients, glow shadows, glass blur, gray text on gray surfaces, emoji as icons. Tint a neutral only if the brand asks for it.
- Disabled controls stay readable. WCAG exempts inactive components from contrast, but aim for at least 3:1 and always keep the label visible. A disabled button needs its reason in text (`aria-describedby`).
- Selected rows, active filters and the current nav item use a second cue besides color: a check, a bar, bold text.

## 7. Typography

| Use | Size | Token | Status |
|---|---|---|---|
| Table cells, dense lists (Office tool) | 14 px | `--font-size-sm` | (A) |
| Secondary meta, captions | 13 px, never below | `--font-size-xs` | (A) |
| Body, labels | 16 px | `--font-size-md` | (A) |
| Phone inputs | 16 px | `--font-size-md` | iOS Safari zooms smaller inputs (observed, test on a device) |
| Section heading | 20 px | `--font-size-lg` | (A) |
| Page title | 24 px | `--font-size-xl` | (A) |

- Use a scale, not ad-hoc sizes. Five steps cover an app UI. A heading and body that differ by less than about 15 percent in size read as the same level.
- Sizes in `rem`, with `html` left at 100 percent. Text then survives user font settings and 200 percent zoom (WCAG 1.4.4).
- Numbers: `font-variant-numeric: tabular-nums` on every table column, price, quantity and counter, so digits align and rows do not jitter.
- Line height: 1.5 for body, about 1.3 in dense tables and lists (A). Long text 45 to 75 characters per line: `max-width: 70ch`.
- Emphasis by weight before size. Avoid bold plus uppercase plus color on one line. Use uppercase only for short labels.
- One family. A second family needs a job. Three is a finding.
- Fonts: the system stack (`system-ui, sans-serif`) costs nothing and always renders umlauts and ß. A custom font is one self-hosted WOFF2 file, subset with the Latin range including ä ö ü ß, with `font-display: swap`. Never load fonts from a third-party CDN: it sends the visitor's IP address to another company, which is a GDPR risk (Assessment, not legal advice).
- A tenant font must be tested with the longest real label and with `ß`, `ü`, `Ä` (see `formats-de.md` §9).

## 8. Spacing, radius and density

- 4 px base. Steps: `--space-1` 4, `--space-2` 8, `--space-3` 12, `--space-4` 16, `--space-5` 24, `--space-6` 32, `--space-7` 48. Padding, margin and gap use only these. Check: no 13, 14, 15 or 17 px values in components.
- Proximity shows relation: a heading sits clearly closer to the block it introduces than to the section above it. If both spaces are equal, grouping disappears.
- Radius: `--radius-sm` 4, `--radius-md` 6, `--radius-lg` 10 px (example values). An inner radius equals the outer radius minus the padding. One border weight (1 px) everywhere.
- Density is a token, not a copy of the stylesheet:

```css
:root { --row-height: 2.5rem; }                 /* default 40 px */
[data-density="compact"] { --row-height: 2rem; }       /* 32 px */
[data-density="comfortable"] { --row-height: 3rem; }   /* 48 px */
tr { min-height: var(--row-height); }
```

- Office tool: user or view picks density; compact 32, default 40, comfortable 48 px (A). Field app: no compact mode, list rows at least 56 px (`field-use.md` §2).
- Use `min-height`, not `height`, so wrapped text and 200 percent zoom do not clip. Targets keep their size in compact density: 24 px floor, 32 px buttons (`accessibility.md` §7).

## 9. Motion and elevation tokens

```css
:root {
  --duration-fast: 120ms;   /* press, hover */
  --duration-base: 200ms;   /* dropdown, popover, toast */
  --duration-slow: 280ms;   /* panel, drawer, dialog */
  --ease-out: cubic-bezier(0.2, 0, 0, 1);   /* enter */
  --ease-in: cubic-bezier(0.4, 0, 1, 1);    /* exit */
}
```

- Ranges: 100 to 150 ms press and hover; 150 to 250 ms small overlays; 200 to 300 ms panels and dialogs; nothing over 400 ms in task flows (A). Rules and reduced motion: `motion.md` §3 and §7.
- Elevation is surface steps first (§5), a shadow second. A shadow token is optional and uses one direction and one blur family across the app.

## 10. Component states and variants

Every interactive component defines these states. Use the list as a build checklist and a review checklist.

| State | Rule |
|---|---|
| Default, hover | Hover only inside `@media (hover: hover)`. Nothing essential appears on hover only. |
| Focus | `:focus-visible`, 2 px outline in `--color-focus`, `outline-offset: 2px`. Never `outline: none` without this replacement. |
| Active | Visible within 100 ms (`motion.md` §2). |
| Disabled | Readable label, not-allowed cursor, reason on screen. |
| Pending | Label stays visible: `Wird gespeichert …` (`states-feedback.md` §4). |
| Invalid | Styled after the first interaction or submit, not on page load. Plain `:invalid` styles an empty required field red before anyone typed. |
| Selected, read-only | A second cue besides color. |

Variants: primary (one per screen), secondary, ghost, danger (only in confirmations and destructive rows). Sizes: default 32 px high (Office tool); Field app 44 px, 48 px with gloves, 56 px for the primary action (`accessibility.md` §7).

```css
.btn { background: var(--color-surface-raised); color: var(--color-text); border: 1px solid var(--color-border); }
.btn:focus-visible { outline: 2px solid var(--color-focus); outline-offset: 2px; }
@media (hover: hover) { .btn:hover { background: var(--color-surface); } }
.btn[aria-disabled="true"] { color: var(--color-text-muted); cursor: not-allowed; }
```

No hardcoded hex in any of these. A new variant gets its tokens first, then its CSS.

## 11. Drift checks

Run these on code, and on a running page when you can (`measuring.md` §6).

| Check | Pass |
|---|---|
| Raw colors outside the token and tenant file: `grep -rnE "#[0-9a-fA-F]{3,8}\b\|rgba?\(" src` | No hits in components |
| Font sizes in `px` in components: `grep -rn "font-size: *[0-9]*px" src` | No hits |
| Distinct `font-size` values on a screen | Only scale steps (five) |
| Distinct text and background colors on a screen | Only tokens; near-duplicate grays mean missing tokens |
| Distinct padding, margin, gap values | Only `--space-1` to `--space-7` |
| Radius values | Only the three radius tokens |
| Undefined `var()` names | None |
| Both themes and all tenant palettes opened | No unreadable pair, logo visible |

Report drift as Medium (off-token colors) and group it by root cause: one missing token, not forty findings.
