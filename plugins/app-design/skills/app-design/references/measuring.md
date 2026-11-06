# Measuring

A written procedure for measuring a running web app with browser DevTools, axe or
Lighthouse, an existing Playwright setup, or by hand. No tool is required: use what
the project and the environment already have. Snippets are illustrations to paste
into the DevTools console, not files to ship.

Load when: you can open the app (a URL or a local dev server) in Review mode, or you
verify a Build result.

Contents: 1 Principles · 2 Setup matrix · 3 Horizontal overflow · 4 Target size ·
5 Contrast · 6 Type and color inventory · 7 Keyboard pass · 8 Preferences pass ·
9 Performance and stability · 10 Network and offline pass · 11 Screen reader
spot-check · 12 Code-only and screenshot-only reviews · 13 Optional automation ·
14 Recording results

## 1. Principles

- Measure, do not guess. Use a test or demo account, never real credentials, and
  name it in the report. Keep saved login state out of the project and out of git.
- Prefer staging or a local instance. On production, read only: never submit
  approvals, orders or protocols to test them.
- Without a browser, say so and list the affected checks under Not checked.

## 2. Setup matrix

Fix the matrix before you start and reuse it for the re-measurement. Record per run:
date, build or commit, URL, browser and version, account, tenant.

| Dimension | Values |
|---|---|
| Widths, Office tool | 1280, 1440, 1920, plus 320 reflow and 200 % zoom |
| Widths, Field app | 360, 390, 414 portrait, one landscape |
| Themes | Dark (default) and light (`[data-theme="light"]` on `html`) |
| Tenants (White-label core) | Default palette, darkest accent, lightest accent |
| Network | No throttling, "Slow 4G", "Offline" (DevTools presets as of 2026-11) |

## 3. Horizontal overflow

Pass: no sideways page scroll at any width (WCAG 1.4.10); scroll inside a table
container is allowed. If the page scrolls but the list stays empty, look for
absolutely positioned children, negative margins and wide pseudo-elements.

```js
const vw = document.documentElement.clientWidth;
const scrollsInside = (el) => {
  for (let a = el.parentElement; a && a !== document.body; a = a.parentElement) {
    const ox = getComputedStyle(a).overflowX;
    if (ox !== "visible" && a.getBoundingClientRect().right <= vw + 1) return true;
  }
  return false;
};
const wide = [...document.body.querySelectorAll("*")].filter((el) =>
  el.getBoundingClientRect().right > vw + 1 && !scrollsInside(el));
console.table(wide.slice(0, 15).map((el) => ({
  el: el.tagName + (el.id ? "#" + el.id : ""), right: Math.round(el.getBoundingClientRect().right) })));
```

## 4. Target size

Pass: every target meets the profile size (`accessibility.md` §7) or a WCAG 2.5.8
exception. Set `min` to the profile value.

```js
const min = 24; // Office tool 24 or 32, Field app 44, 48 or 56
const sel = "button, a[href], select, textarea, summary, input:not([type=hidden]), [role=button]";
console.table([...document.querySelectorAll(sel)]
  .map((el) => ({ el, r: el.getBoundingClientRect() }))
  .filter(({ r }) => r.width > 2 && r.height > 2 && (r.width < min || r.height < min))
  .filter(({ el }) => !(getComputedStyle(el).display === "inline" && el.closest("p, li")))
  .map(({ el, r }) => ({ name: (el.innerText || el.getAttribute("aria-label") || "").trim().slice(0, 30),
    width: Math.round(r.width), height: Math.round(r.height) })));
```

Inline links in text are exempt and filtered out. A hit area enlarged by a
pseudo-element is larger than the box shown; check those and the spacing exception
by hand.

## 5. Contrast

Pass: the thresholds in `accessibility.md` §6.
- Sweep with axe DevTools or the Lighthouse accessibility audit, per theme and per
  tenant palette. For single text pairs, the DevTools color picker shows the ratio.
- Non-text contrast (input borders, icons, focus ring) is missed by most automatic
  checks: pick both colors and compute the ratio.
- Text over photos: DOM tools cannot see the pixels behind it. Use a color picker on
  the worst spot of a screenshot, or report an Assessment. Log each failing pair with
  both tokens, ratio, required ratio, theme and tenant.

## 6. Type and color inventory

A drift test: the page should use only values from the token scale.

```js
const count = (prop) => {
  const m = new Map();
  for (const el of document.body.querySelectorAll("*")) {
    if (![...el.childNodes].some((n) => n.nodeType === 3 && n.textContent.trim())) continue;
    const v = getComputedStyle(el)[prop]; m.set(v, (m.get(v) || 0) + 1);
  }
  return [...m].sort((a, b) => b[1] - a[1]);
};
console.table(count("fontSize")); console.table(count("fontWeight")); console.table(count("color"));
```

Pass: each font size maps to `--font-size-xs` to `--font-size-xl`, each text color to
a color token of the active theme; values used once or twice are typical drift. In
code, search outside the token file, for example
`grep -rnE "#[0-9a-fA-F]{3,8}\b|rgba?\(" src` and `font-size: *[0-9]+px`.

## 7. Keyboard pass

Pass: the core task completes by keyboard; order follows the layout; every stop shows
a ring; nothing hides behind sticky bars; overlays keep focus and return it.
1. Load the screen, paste the logger, click into the address bar, then Tab through.
   Note the order, stops without a visible ring, stops off screen or under a sticky bar.
2. Open each dialog, menu and side panel, Tab through it, press Escape. Focus must
   start inside and end on the trigger.

```js
document.addEventListener("focusin", (e) => {
  const el = e.target, cs = getComputedStyle(el);
  console.log(el.tagName, (el.innerText || el.getAttribute("aria-label") || "").trim().slice(0, 30),
    "outline:", cs.outlineStyle, cs.outlineWidth, "top:", Math.round(el.getBoundingClientRect().top));
});
```

A stop with `outline: none` may still show a ring via shadow, border or a child: judge
the screen, not only the log. `document.activeElement` shows the current focus.

## 8. Preferences pass

DevTools, Rendering panel, "Emulate CSS media feature" (Chrome naming as of 2026-11).
Pass: with `prefers-reduced-motion: reduce` nothing slides, the shimmer stops and
nothing stays invisible after an entrance; with `forced-colors: active` borders, focus
rings, icons and status chips stay visible; with `prefers-contrast: more` the layout
holds. Then zoom to 200 % and inject the text spacing CSS from `accessibility.md` §11:
nothing is cut off, clipped or overlapping.

## 9. Performance and stability

"Good" at the 75th percentile of real users: LCP 2.5 s, INP 200 ms, CLS 0.1 (web.dev,
as of 2026-11). FID is retired; INP replaced it in 2024.
- Logged-in tools: INP and CLS matter more than LCP. Users wait on sorts and saves.
- DevTools and Lighthouse give lab numbers from one run. Say so; never present one lab
  run as the app's Core Web Vitals.
- INP: Performance panel, CPU throttling 4x; sort and filter the largest table, type
  into the search, note the slowest interaction.
- CLS: Rendering panel, "Layout Shift Regions". Pass: nothing the user reads or is
  about to click moves. Also note console errors, failed requests and double requests.

## 10. Network and offline pass

Pass: no input is lost, the state is always visible, nothing is sent twice. On
"Slow 4G", submit: the button shows pending within 100 ms and a second press sends no
second request. Switch to "Offline" during a submit: a clear state, input kept.
Reload with a pending queue: the items are still there. Back online: the queue sends
once and the status words change as defined. Details: `offline-sync.md` §8.

## 11. Screen reader spot-check

A short listen to the core task. Office tool: NVDA on Windows. Field app: VoiceOver on
iOS, TalkBack on Android. With `lang="de"` on `html` the reader speaks German. Pass:
each control gives name, role and state; cells come with their column headers; errors
are announced with their field; status messages (`124 Aufträge`) are announced once.

## 12. Code-only and screenshot-only reviews

Code alone can verify: a missing `label` or accessible name, `outline: none` without a
replacement, positive `tabindex`, a clickable `div`, raw hex and pixel font sizes
outside the token file, a missing empty or error branch, wrong input types
(`type="number"` for article numbers), `user-scalable=no`, no reduced-motion handling.
Contrast in context, overflow, focus order, timing and layout shifts stay Assessment.
A screenshot shows hierarchy, wording, rough contrast and drift, nothing interactive.

## 13. Optional automation

If the project already has Playwright, axe or similar, run the same checks there (the
matrix of §2, the snippets of §3 to §7, an axe scan per theme). Never add a dependency
only for the review. Keyboard, screen reader and wording checks stay manual.

## 14. Recording results

One log per run, reused for `review-procedure.md` §14; each Verified finding cites a row.

| Check | Screen | Width | Theme | Tenant | Value | Required | Result |
|---|---|---|---|---|---|---|---|
| Contrast muted text | Aufträge | 1440 | light | default | 3.1:1 | 4.5:1 | Fail |
| Overflow | Abnahme | 360 | dark | default | none | none | Pass |
