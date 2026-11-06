# Field Use on the Phone

The phone on the building site and in the warehouse: one hand, gloves, sun, noise, weak network, voice, camera and scanners. This file is the Field app profile in detail. Offline behavior lives in offline-sync.md, form patterns in forms-protocols.md.

Load when: building or reviewing a phone-first screen, a voice or camera feature, a scan step, or anything used outdoors or with gloves.

Contents: 1 Field conditions, 2 Touch targets and the thumb, 3 Sunlight and readability, 4 Phone layout and the on-screen keyboard, 5 Voice input, 6 Camera and photos, 7 Camera scanning, 8 Hardware scanners, 9 Feedback when eyes are busy, 10 Testing in the field.

Status: WCAG criteria by number. Browser and device facts carry "as of 2026-11, re-check". Everything else is our own assessment (A). German examples use Sie as a placeholder for the per-tenant setting (wording-de.md §2).

## 1. Field conditions

Design for the worst hour of the day, not the demo.

| Condition | What it means for the screen |
|---|---|
| One hand, thumb only | Every frequent action sits in the lower half. No two-hand gestures |
| Gloves, dirty or wet fingers | Large targets with gaps (§2). No precision drags. Few typing steps |
| Sunlight, glare | High contrast, heavy weights (§3) |
| Noise | Sound is never the only signal. Voice input shows what it heard (§5) |
| Interruptions | Phone call, app switch, screen lock. State survives all of them (forms-protocols.md §6) |
| Weak or no network | Work continues, status is honest (offline-sync.md) |
| Shared or older phones | Test at 360 px width and with 4x CPU throttling. Expect old WebViews |

- Widths to check: 360, 390, 414 portrait and one landscape. Do not lock orientation (WCAG 1.3.4).
- The screen may lock in the middle of a protocol. Nothing may depend on staying awake.
- Each task has a short path. Count the taps from the home screen to the main action. Prefer choosing over typing (chips, steppers, lists).

## 2. Touch targets and the thumb

| Rule | Value | Status |
|---|---|---|
| Absolute floor | 24 x 24 CSS px or the spacing exception | WCAG 2.5.8 |
| Default touch target | 44 x 44 px | (A) |
| Field app with gloves | 48 px minimum, 56 px for primary actions | (A) |
| The one main control of a screen (`Sprechen`, `Senden` in the bottom bar) | 64 px or more | (A) |
| Gap between adjacent targets | at least 8 px | (A) |
| List rows | at least 56 px high | (A) |

- Measure the hit area, not the icon. Enlarge a small icon with padding or a pseudo-element, and keep the enlarged areas from overlapping neighbors.
- Primary action at the bottom, in the lower third of the screen. The top bar holds orientation (title, back) and rare actions.
- Destructive actions sit apart from the primary one: at least 16 px gap (A) and lower visual weight. Never put `Löschen` next to `Speichern` at equal size.
- No swipe-only or long-press-only action. Every gesture has a visible button (WCAG 2.5.1, 2.5.7).
- Act on release, not on press. Highlight on touch-down, commit on touch-up, and let the user cancel by moving the finger away (WCAG 2.5.2). Use `click` or `pointerup`, never `pointerdown`, for actions.
- Nothing hover-only. Gate hover styles with `@media (hover: hover) and (pointer: fine)`.
- Avoid a floating button next to a sticky submit bar (layout-navigation.md §3).

```css
.btn { min-block-size: 48px; min-inline-size: 48px; padding-inline: var(--space-4);
       touch-action: manipulation; }
.btn--primary { min-block-size: 56px; }
.icon-btn { position: relative; }
.icon-btn::after { content: ""; position: absolute; inset: -8px; }
```

## 3. Sunlight and readability

- Body text and key labels reach 7:1 against their background (A, same number as WCAG 1.4.6 AAA). The general 4.5:1 of WCAG 1.4.3 is not enough outdoors.
- Check the numbers in both themes and in the tenant palette. If a brand accent fails as text, use a darker step for text and keep the brand color for large fills (tokens-theming.md §4).
- Key labels and values in weight 600 or heavier (A). Body 16 px minimum. No thin or light gray text.
- Icons with a stroke of at least 2 px (A). Input borders at least 3:1 (WCAG 1.4.11), preferably 2 px wide.
- Status by text and icon, never by color alone (WCAG 1.4.1). Disabled controls stay readable.
- A light theme often reads better in bright sun (Assessment). Offer `Darstellung: Hell, Dunkel, Automatisch` as a user setting on the Field app.
- Test outdoors on a bright day. Indoors, a rough approximation is half screen brightness viewed at an angle (Assessment).

## 4. Phone layout and the on-screen keyboard

- Sticky bottom action bar with safe-area padding. Hold at most one primary and one secondary button. Add `viewport-fit=cover` to the viewport meta.
- Use `min-height: 100dvh` instead of `100vh`, so the browser bar does not cut the layout.
- Inputs use 16 px font size. Smaller inputs make iOS zoom in on focus (observed behavior, test on a device). Never block zoom (WCAG 1.4.4).
- The focused field stays visible above the keyboard, and the sticky bar must not cover it (WCAG 2.4.11). Reserve space with `scroll-padding-bottom` equal to the bar height.
- Where `visualViewport` is available, lift or hide the bottom bar while the keyboard is open. Chromium also supports `interactive-widget=resizes-content` in the viewport meta (as of 2026-11, re-check).
- Use `overscroll-behavior-y: contain` on the scroll container of a form so a pull cannot trigger a browser refresh and wipe input. Offer an explicit refresh button instead of pull-to-refresh.
- Set `enterkeyhint` so the keyboard's action key matches the step (forms-protocols.md §2).

```js
const vv = window.visualViewport;
vv?.addEventListener("resize", () => {
  const covered = window.innerHeight - vv.height;
  document.documentElement.style.setProperty("--keyboard-h", covered + "px");
  document.activeElement?.scrollIntoView({ block: "center" });
});
```

## 5. Voice input

Flow: the fitter speaks the material need, the app turns it into lines, the warehouse gets a Kommissionierauftrag. Voice is an accelerator. It is never the only path.

- Activation: the main control of the screen, at least 64 px (§2), labeled `Sprechen`. Tap to start, tap to stop. Holding a button is tiring with gloves (Assessment). Never start recording before the tap.
- Visible states with text, not only animation: `Bereit`, `Hört zu …`, `Wird verarbeitet …`, `Nicht verstanden` (wording-de.md §11). A live level indicator that follows the voice shows the microphone is on and hears something, for as long as it is on.
- Show a live transcript while the user speaks, so misrecognition is caught at once.
- Turn the result into editable lines (`Menge`, `Einheit`, `Artikel`). Each line can be changed by touch and removed (`Zeile entfernen`). Mark uncertain lines with the text `Bitte prüfen`.
- Match spoken names against the article catalog and show candidates (`Meinten Sie: Kupferrohr 15 mm?`). Convert spoken numbers and units (`fünfzehn Millimeter` to `15 mm`).
- Confirm what was understood before sending: `Verstanden: 3 × Kupferrohr 15 mm. Stimmt das?` Buttons: `Senden` and `Korrigieren` (wording-de.md §11).
- On failure give a way forward: record again with an example, edit the text, or add the article by hand (`Artikel hinzufügen`). Never a dead end. Manual entry must always be there, and the phone keyboard's own dictation key is a zero-code fallback.
- Language `de-DE`, or the tenant locale. Limit a recording (about 60 s, A) and say so.
- Offline: speech recognition in the browser usually needs the network. Say it at the mic button, not in the general offline banner: `Spracheingabe braucht Netz. Artikel bitte von Hand eingeben.` An alternative is to store the audio on the device and transcribe after sync (offline-sync.md §3), shown as `Aufnahme auf dem Gerät gespeichert`.
- Privacy is part of the UI. The browser speech API in Chrome sends audio to the vendor's servers (as of 2026-11, re-check), so check data protection and the processing contract before using it. The alternative is `MediaRecorder` plus server-side transcription by a processor under contract. Say once, in plain words, where the audio goes. Do not keep audio longer than the process needs.
- Ask for microphone permission on the first tap on `Sprechen`, with a one-line reason. Denied state: explain where to allow it and keep the manual path. Stop all tracks when done.

```js
const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
if (!SR) showManualEntryOnly();
else {
  const rec = new SR();
  rec.lang = "de-DE"; rec.interimResults = true;
  rec.onresult = e => showTranscript([...e.results].map(r => r[0].transcript).join(""));
  rec.onerror = e => recoverWithManualEntry(e.error);
  rec.onend = () => setState("Bereit");
}
```

## 6. Camera and photos

- Default: `<input type="file" accept="image/*" capture="environment">`. It opens the system camera, needs no permission code, and works on weak phones. Give a second input without `capture` for `Aus Galerie wählen`.
- Use a live camera stream (`getUserMedia`) only for scanning (§7) or when an in-page preview is required. Ask for permission when the user taps, never at load. Needs HTTPS.
- A phone with little memory may reload the page while the camera app is open. Save the draft before opening the camera (forms-protocols.md §6).
- Resize before storing and uploading. Assessment: long edge about 2000 px, JPEG quality about 0.8. Keep the orientation right (`createImageBitmap(file, { imageOrientation: "from-image" })`). Strip location data unless the process needs it (data protection, Assessment).
- Create a small thumbnail at once and show it. Upload the full photo in the background (offline-sync.md §7). Revoke object URLs (`URL.revokeObjectURL`) and avoid holding many full-size bitmaps.
- Resize large photos automatically. Show an error only if the photo is still too large after resizing (text in wording-de.md §7).
- Map `getUserMedia` errors to useful states:

| Error | Show |
|---|---|
| `NotAllowedError` | Where to allow the camera, plus `Aus Galerie wählen` |
| `NotFoundError` | Hide the camera button, keep gallery and manual entry |
| `NotReadableError` | `Die Kamera wird von einer anderen App genutzt.` |
| `OverconstrainedError` | Retry with looser constraints |

- Stop every track (`track.stop()`) as soon as the camera view closes or pauses; the system camera light then turns off.
- Home Screen web apps on iOS may ask for the camera again on each start (observed, as of 2026-11, re-check). Keep a short in-context hint.
- Captions and alt text: forms-protocols.md §8 and accessibility.md §13.

## 7. Camera scanning

Use camera scanning for Artikel, Lagerplatz or Kommission codes. It speeds up typing and never replaces it.

- Place `Scannen` (48 px) next to the field it fills. Beside it, keep manual entry and `Aus Foto lesen`. Hide the scan button when the device has no camera.
- Check support first with `'BarcodeDetector' in window`, then ask `BarcodeDetector.getSupportedFormats()` whether the formats you need are there. Native support is partial: Chrome on Android yes, desktop Chrome only on some systems, Safari and Firefox not reliable (as of 2026-11, re-check). Use a WASM decoder as fallback, load it only when the scanner opens, and host it yourself (CSP, offline).
- Enable only the symbologies you expect (for example EAN-13, Code 128, QR). Fewer formats scan faster and misread less.
- Show a frame shaped like the code (wide for 1D, square for QR), decode only inside it, and keep the center clear.
- Pause the feed when a code is found, so a second code is not read by accident. Accept a value only after it decodes the same way in several frames in a row (2 to 3, A).
- Torch button when `track.getCapabilities().torch` exists. If you build pinch zoom, add zoom buttons as a single-pointer alternative (WCAG 2.5.1).
- After about 5 to 10 s without a hit (heuristic), show help: `Mehr Licht, ruhig halten oder die Nummer eintippen.`
- Announce the result in a status region (`Gescannt: 4711-08`). No shutter tap while aiming.
- Auto-act only on codes your own system issued (Auftrag, Artikel, Lagerplatz). Any other URL gets a preview with the domain first and opens only after a tap. Never open payment or login links from a scan.
- Unknown code: show the raw value and offer manual search. Do not ask users to scan a code that is shown on the same phone.
- Printed labels from our system carry the human-readable number next to the code, so a damaged label can still be typed.
- Stop the camera tracks on leaving the view. After a long idle time pause with `Scannen fortsetzen`, and keep the state.

## 8. Hardware scanners

A Bluetooth or USB scanner in keyboard mode types the code like a keyboard. Dedicated devices can deliver scans by an SDK or intent instead, which is more robust. Prefer that where the project controls the device. Web apps usually get keystrokes.

- A keyboard scanner needs a focused field. Keep the scan field focused, and never let toasts, banners or dialogs steal focus.
- The scanner sends Enter or Tab after the code. Configure the suffix on the scanner and use it as the end signal. Do not guess the end by timeout alone.
- On scan fields, keep the on-screen keyboard closed with `inputmode="none"`, not `readonly` (a readonly field ignores the scanner). Provide `Manuell eingeben`, which switches the field to `numeric` or `text`.
- German keyboard layout: the scanner maps characters by its own layout setting, often US. On a German phone this swaps Y and Z and breaks punctuation. If a code fails the format check, say `Scanner-Layout passt vielleicht nicht. Bitte erneut scannen.` and not `Artikel nicht gefunden`.
- Group separators (ASCII 29) in GS1-128 codes are often lost by keyboard input. Configure the scanner to send a printable stand-in, or use SDK delivery.
- Route by content, not only by focus. A pattern tells Lagerplatz, Artikel and Kommission apart. Scans must work while a dialog is open.
- Wrong type at this step: say what was scanned and what is expected: `Das ist Lagerplatz A-12-03. Bitte den Artikel scannen.`
- The app validates codes itself, including check digits where the code has one (GTIN mod-10). Do not rely on the scanner. Typed and scanned values go through the same validation.
- To tell a scan from typing without a prefix, use timing as a last resort. People type about 100 to 200 ms per character, scanners a few ms (A). Calibrate per device. Bluetooth delays and remote sessions break it.

```js
const GAP_MS = 30, MIN_CHARS = 6; let code = "", prevKeyAt = 0; // (A), calibrate per device
document.addEventListener("keydown", (ev) => {
  const gap = ev.timeStamp - prevKeyAt;
  prevKeyAt = ev.timeStamp;
  if (gap > GAP_MS * 3) code = "";          // slow key: a person, start over
  if (ev.key === "Enter") {
    if (code.length >= MIN_CHARS) handleScan(code);
    code = "";
  } else if (ev.key.length === 1) code += ev.key;
}, { capture: true });
```

| Situation | Handling |
|---|---|
| Wrong article for this pick | Block. Show expected and scanned, require a rescan. No override without reason and audit |
| Duplicate scan | Same code within a short time: ignore. Intended repeat: add one and show the updated count |
| Unknown code | Show the raw value. Offer manual search. Never create master data on the spot |
| Too many scanned | Stop at the limit: `10 von 10. Dieser ist zu viel.` Offer `Zurücklegen` |
| Bad format or check digit | `Nicht sauber gelesen. Bitte erneut scannen.` |
| Server error | Show the specific message and a reference code |

- Batch work shows a running count and the last value: `3 von 10 gescannt`. `Letzten Scan rückgängig` is one tap and not modal. Collect scans locally and send them in one call with a result per item.
- Every scan step has a manual path. Record the input method (`gescannt` or `manuell`). A rising share of manual entries points to bad labels or a bad flow.
- Errors clear by the next valid scan or a 56 px button, not by a small OK button.

## 9. Feedback when eyes are busy

Each scan or voice result has one of three outcomes, shown in a way that works without reading.

| Outcome | Visual | Sound | Vibration |
|---|---|---|---|
| Angenommen | Check icon, value, brief green state | Short high tone | One short pulse |
| Warnung | Warning icon, text, amber banner | Mid tone | Two short pulses |
| Abgelehnt | Cross icon, reason, stays until acknowledged or rescanned | Low, longer tone | One long pulse |

- Visual first: shape, icon and text carry the meaning, color supports (WCAG 1.4.1).
- Sound is optional and never the only signal. Offer a per-user setting for sound and vibration. Keep the vocabulary to these three sounds, because workers mute noises that mean nothing.
- Create or resume the `AudioContext` inside a tap (for example `Scannen starten`), so later beeps pass autoplay rules.
- `navigator.vibrate` does not work in iOS Safari (as of 2026-11, re-check). Never rely on it. Fire vibration after the capture, not during.
- Status messages go through live regions: `role="status"` for accepted, `role="alert"` only for rejected (accessibility.md §9).

## 10. Testing in the field

Run this on a real phone. Emulators do not show glare, gloves or memory limits.

| Check | Pass |
|---|---|
| One-handed use, thumb only | Every frequent action reachable without shifting the grip |
| Work gloves on | Primary and secondary actions hit on the first try. No accidental neighbor hits |
| Outdoors in bright light | Body text and key labels readable without shading the screen |
| Slow 4G throttling (DevTools preset) | Screens usable, status honest, no blocked form |
| Airplane mode during submit | Input kept, status `Auf dem Gerät gespeichert` (offline-sync.md §8) |
| App switch or phone call mid-protocol | Return lands on the same section with all values |
| Older mid-range Android, 360 px | No layout break, input latency acceptable |
| Real tenant palette | Contrast checks in §3 pass |

Record the phone model, OS, browser and gloves used. Method for measured values: measuring.md §10.
