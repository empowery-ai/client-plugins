# Forms and Protocols

Rules for office forms and for long field protocols (Abnahmeprotokoll, Montageprotokoll), including photos, signatures and forms rendered from a form builder. A form is where users lose data and patience, so every rule here protects input first.

Load when: building or reviewing any form, a protocol with sections, a photo or signature field, a form-builder renderer, or a login.

Contents: 1 Labels and layout, 2 Input types, 3 Validation, 4 Submit and pending, 5 Long protocols, 6 Autosave and drafts, 7 Defaults and redundant entry, 8 Photo fields, 9 Signature field, 10 Forms from a form builder, 11 Edit conflicts, 12 Login.

German examples use Sie. The real form of address is a per-app or per-tenant setting (wording-de.md §2). Status: WCAG criteria are cited by number; values marked (A) are our own assessment.

## 1. Labels and layout

- Every field has a visible `<label for="...">`. A placeholder is never the label (it vanishes on input and fails contrast more often than not).
- Put the label above the field. One column. Two columns only for short, closely related pairs (`PLZ` and `Ort`, `Von` and `Bis`) in the Office tool profile. The Field app always uses one column.
- Group related fields in `<fieldset>` with `<legend>`. Radio and checkbox groups always need one.
- Placeholder text is an example, not an instruction: `z. B. 12,5`. Its contrast must still reach 4.5:1 (WCAG 1.4.3).
- No colon after a label. Wording of labels: wording-de.md §6.
- Pick one marking convention per app and keep it. Default: mark the optional fields with `(optional)` when most fields are required. If most are optional, mark required ones with `*` and put `* Pflichtfeld` once above the form. Never mark by color alone.
- Field width follows the expected content: `PLZ` narrow, `Artikelnummer` medium, `Bemerkung` full width.
- Ask only for what the process needs. Every field that can be filled from the Auftrag is prefilled (§7).
- Primary button on the right (Office tool) or full width in a sticky bottom bar (Field app). Secondary action on the left. Never hide the submit button below a long scroll without a sticky bar.

```html
<div class="field">
  <label for="flaeche">Fläche (m²)</label>
  <input id="flaeche" name="flaeche" type="text" inputmode="decimal"
         autocomplete="off" aria-describedby="flaeche-hint">
  <p id="flaeche-hint" class="hint">z. B. 12,5</p>
</div>
```

## 2. Input types

Use the type that gives the right keyboard and the right parsing. Set `type`, `inputmode`, `autocomplete` and `enterkeyhint` together.

| Data | Markup | Note |
|---|---|---|
| Decimal (Menge, Fläche, Preis) | `type="text" inputmode="decimal"` | Parse German comma, see formats-de.md §3 |
| Whole count (Stück) | `type="text" inputmode="numeric" pattern="[0-9]*"` | Field app: stepper buttons at 56 px beside the input |
| Artikelnummer, Kommission, Charge | `type="text" autocomplete="off" spellcheck="false"` | Never `type="number"`: it drops leading zeros and rejects spaces and dashes |
| E-Mail | `type="email" inputmode="email" autocomplete="email"` | |
| Telefon | `type="tel" autocomplete="tel"` | Accept spaces and `+49` |
| PLZ | `type="text" inputmode="numeric" autocomplete="postal-code"` | 5 digits for DE, 4 for AT and CH: tenant setting |
| Datum, Uhrzeit | `type="date"`, `type="time"` | Native pickers work well on phones. Submitted value is ISO 8601. Display via `Intl` |
| Suche | `type="search"` | |
| Passwort, Code | see §12 | |

- Why not `type="number"` for decimals: the browser shows and accepts the decimal separator by its own locale rules, the mouse wheel can change the value, and grouping dots are rejected (browser behavior, as of 2026-11, re-check).
- Set `autocomplete` tokens only for data about the user (`email`, `tel`, `username`, `given-name`, `postal-code`, `one-time-code`), which meets WCAG 1.3.5. Set `autocomplete="off"` for internal data such as article numbers.
- `enterkeyhint`: `next` on inner fields, `done` or `send` on the last field, `search` in search fields.
- Choice controls (A): up to 5 options as radio buttons, 6 to 15 as native `<select>`, more than 15 as a combobox with typing and filtering. On phones the native select opens the system picker, which is easy to hit with gloves.

## 3. Validation

- Do not style `:invalid` before the user has interacted. Validate on blur, on submit, and after a first error re-validate on every input.

| Moment | Use for | Avoid for |
|---|---|---|
| On blur | Most fields: format, range, required | Fields the user is still moving through with Tab and may skip on purpose |
| On every input | After a first error, to clear it as soon as the value is fine | Showing a first error while the user is still typing |
| On submit | Cross-field rules, server-side rules | Being the only moment on a long form |
- Message next to the field, with icon and text, in `var(--color-danger)`. The field border needs 3:1 (WCAG 1.4.11). Link the message with `aria-describedby` and set `aria-invalid="true"`.
- Keep the submit button enabled. On a failed submit show what is missing. A disabled button gives no reason and fails on touch.
- On a failed submit of a long form: show a summary at the top (`3 Angaben fehlen oder sind fehlerhaft`) with links to each field, and move focus to the summary (`tabindex="-1"`). On a short form (up to about 5 fields, A): move focus to the first invalid field instead. Use one of the two, not both.
- Use `role="alert"` only for the summary or for an urgent block error. Per-field messages are read through `aria-describedby` (accessibility.md §9).
- Keep all input after an error, also after a server error (core principle 3 in SKILL.md).
- Cross-field rules get their own message: `Das Enddatum liegt vor dem Startdatum.` Mark both fields.
- Separate error from warning. An implausible value (`Menge 10.000 Stk.`) gets a warning with a confirm: `Ungewöhnlich hoch. Stimmen 10.000 Stk.?` It does not block.
- Map server errors (HTTP 422) to fields by field key. An error without a field becomes a banner above the form (states-feedback.md §7).
- Message text: wording-de.md §7. Satisfies WCAG 3.3.1 (identify the error) and 3.3.3 (suggest a fix).

```html
<input id="menge" aria-invalid="true" aria-describedby="menge-err">
<p id="menge-err" class="error">
  <svg aria-hidden="true">…</svg>
  Menge fehlt. Geben Sie eine Zahl ein, z. B. 12,5.
</p>
```

## 4. Submit and pending

- The button names the action: `Protokoll abschließen`, `Auftrag freigeben`. Never `Senden` or `OK` alone.
- Visible press feedback within 100 ms. Pending state after the press: keep the label and add the state (`Wird gespeichert …`). Spinner rules: states-feedback.md §2 and §4.
- Guard double submit in code, not only by styling: ignore a second activation while a request runs, including Enter in a field. Use `aria-disabled="true"` so the button keeps focus and its text.
- Create the idempotency key when the form opens or the action is first made, not on click. Reuse it on every retry (offline-sync.md §4). A double press then creates one record, not two picking orders.
- If a request runs longer than about 10 s (A), say so and say that the input is safe: `Dauert länger als üblich. Ihre Eingaben sind gesichert.`
- After success: show the result and the next step (wording-de.md §8), move focus to a sensible place (the heading of the next view), and clear the draft (§6).

## 5. Long protocols

A protocol with more than about 12 fields becomes a list of sections, not a strict wizard.

- Show a section list with status per section (`Offen`, `In Arbeit`, `Vollständig`, `Fehlerhaft`, wording-de.md §9) and overall progress like `3 von 7 Abschnitten`. Status is text or icon, not color alone.
- The user can jump to any section. Do not force an order unless a real dependency exists.
- Save per section when the user leaves it (§6). Leaving an incomplete section is allowed. Mark it `In Arbeit`. Block only the final `Protokoll abschließen`, and then list what is missing with links to the fields.
- Conditional sections (`Wärmepumpe` only if the Auftrag has one) are hidden, not disabled, and the progress count adapts.
- Add a review view before the signature: all answers read-only, grouped by section, with `Bearbeiten` links.
- Field app: one section per screen, sticky bottom bar with `Zurück` and `Weiter`, the section list as the entry screen. Office tool: section list as a left column or an accordion on wide screens.
- Markup: `<nav aria-label="Abschnitte"><ol>` with `aria-current="step"` on the open section, one `<h2>` per section.
- Resume after interruption: reopening the protocol lands on the last open section with all values restored.

```html
<nav aria-label="Abschnitte">
  <p>3 von 7 Abschnitten</p>
  <ol>
    <li><a href="#rohre">Rohrleitungen <span>Vollständig</span></a></li>
    <li><a href="#druck" aria-current="step">Druckprobe <span>In Arbeit</span></a></li>
    <li><a href="#fotos">Fotos <span>Offen</span></a></li>
  </ol>
</nav>
```

## 6. Autosave and drafts

- Save locally on change, debounced to about 500 to 1000 ms (A), and again on blur and on `visibilitychange` to hidden. Store in IndexedDB, keyed by form, record and user. Small forms may use `localStorage`.
- Show state in plain text: `Entwurf gespeichert, 14:32 Uhr`. If saving fails: `Entwurf konnte nicht gespeichert werden. Speicher prüfen.` Announce through a polite status region, not on every keystroke (accessibility.md §9).
- On open, if a draft is newer than the server record, offer it: `Entwurf vom 06.11.2026, 14:32 Uhr gefunden.` Buttons `Entwurf fortsetzen` and `Entwurf verwerfen`. Discarding asks for confirmation (wording-de.md §8).
- Survive reload, back navigation, tab close and a camera app that kills the page on low-memory phones (field-use.md §6). Save before opening the camera.
- The draft is not a submission. The server record only reaches `Eingereicht` through the submit action.
- Store a schema version with the draft. If the form schema changed, migrate the values or say so, never drop them silently.
- Delete the draft after a confirmed successful submit. Keep it on a failed submit.

## 7. Defaults and redundant entry

WCAG 3.3.7 (Level A): do not make users enter again what they already gave in the same process.

- Prefill from the Auftrag: Kunde, Objektadresse, Auftragsnummer, Gerät. Show the source (`Aus Auftrag 4711`) and keep it editable.
- Carry over from the previous protocol of the same Auftrag: Monteur, Datum, Anlagentyp. Offer `Werte vom letzten Protokoll übernehmen` as one explicit action for repeating visits.
- Never prefill what must be a fresh statement: measured values, Abnahme confirmation, signature, signing time.
- A default date of today is fine. A default `Ja` on a safety or acceptance question is not.
- Exceptions to 3.3.7: re-entry that is essential (confirm password) or required for security.

## 8. Photo fields

- Label with the purpose and the count rule: `Fotos Rohrleitung (mind. 2)`. Show progress: `1 von mind. 2 Fotos`.
- Two actions, each at least 48 px: `Foto aufnehmen` and `Aus Galerie wählen`. Capture mechanics: field-use.md §6.
- Show a thumbnail immediately after capture, before any upload. A tap opens it larger.
- Each photo has an optional caption field (`Beschriftung`). The caption is the alt text of the photo in the protocol (accessibility.md §13).
- `Foto entfernen` is a 48 px button with an accessible name that includes the position (`Foto 2 entfernen`). Prefer undo over a confirm dialog (states-feedback.md §9).
- Per photo status in words from wording-de.md §9: `Auf dem Gerät gespeichert`, `Wird gesendet`, `Gesendet`, `Senden fehlgeschlagen` with `Erneut senden`. Upload behavior: offline-sync.md §7.
- A missing required photo is named in the missing list: `Foto Rohrleitung fehlt (1 von 2).`
- Show max count and size only when the limit can be hit. The app resizes large photos itself, so no `Datei zu groß` error for normal camera files.

```html
<fieldset>
  <legend>Fotos Rohrleitung (mind. 2)</legend>
  <p role="status">1 von mind. 2 Fotos</p>
  <button type="button" class="btn">Foto aufnehmen</button>
  <button type="button" class="btn">Aus Galerie wählen</button>
  <ul><li><img src="…" alt="Rohrleitung vor der Druckprobe"> <button type="button">Foto 1 entfernen</button></li></ul>
</fieldset>
```

## 9. Signature field

- A pad at least 160 px high and full width, with a visible border (3:1), a baseline and the hint `Hier unterschreiben`. Set `touch-action: none` on the pad only, so drawing does not scroll the page.
- `Löschen` clears the pad. `Übernehmen` commits it. Both are at least 48 px. On phones, offer a full-screen signing view so the page does not move. Do not lock orientation.
- Beside the pad: `Name in Druckbuchstaben` (required) and, where the process needs it, `Funktion` (Kunde, Monteur).
- Commit strokes on pointer release (`pointerup`, also `pointercancel`). A stray touch outside the pad draws nothing.
- After `Übernehmen`: show the stamp `Unterschrieben am 06.11.2026, 14:32 Uhr`, and lock the signed content (read-only). Changing it needs `Unterschrift zurückziehen`, which asks for confirmation and clears the signature.
- Drawing is an essential dragging movement (WCAG 2.5.7 exception). People who cannot draw need another path where the process allows it: typed name plus a checkbox `Ich bestätige die Abnahme`. Whether that is valid for the contract is for the process owner, not for the UI.
- Give the pad an accessible name (`Unterschriftenfeld`) and announce the result: `Unterschrift erfasst`.

## 10. Forms from a form builder

A renderer draws many protocols from one schema. It must stay predictable.

| Schema field type | Render as |
|---|---|
| Text, Langtext | `input type="text"`, `textarea` |
| Zahl, Dezimalzahl | §2 decimal or numeric input, unit in the label |
| Datum, Uhrzeit | native date or time input |
| Auswahl (einfach) | radio up to 5, `select` up to 15, combobox above |
| Auswahl (mehrfach) | checkbox group in a fieldset |
| Ja/Nein/Entfällt | three radio buttons, never a toggle with an unset state |
| Foto | §8 |
| Unterschrift | §9 |

An illustrative schema field (names are ours, adapt to the builder in use):

```json
{ "key": "druck_bar", "type": "decimal", "label": "Prüfdruck (bar)",
  "required": true, "min": 0, "max": 25,
  "showIf": { "key": "druckprobe", "equals": "ja" },
  "messages": { "required": "Prüfdruck fehlt. Geben Sie eine Zahl ein, z. B. 6,5." } }
```

- Same type, same markup, same spacing, same label, hint and error slots in every protocol. IDs come from the stable field key in the schema, never from the position.
- Conditional logic shows a dependent field right after the field that controls it, so reading order matches. If a focused field becomes hidden, move focus to its controlling field. Do not delete the values of hidden fields silently: exclude them from submit and keep them until submit.
- Validation comes from the schema (required, min, max, pattern, message in German). The renderer does not invent rules. An unknown field type renders as a plain text field and is logged.
- Store the schema version with every filled protocol. Old protocols open with their own version.
- Builder (Office tool): reorder by drag handle and by `Nach oben` and `Nach unten` buttons (WCAG 2.5.7). Show a preview at phone width. A field key cannot change once protocols use it.

## 11. Edit conflicts

Two people edit the same record, or a queued edit meets a newer server version.

- Send the record version (`version` field or ETag) with each update (`If-Match`). The server answers HTTP 409 on mismatch.
- On 409 never overwrite and never discard the user's input. Keep their values and show: `Dieser Auftrag wurde geändert, während Sie ihn bearbeitet haben.`
- Show only the fields where both sides differ, one row per field: `Ihr Wert`, `Aktueller Wert`, choice per field. Fields changed on one side only merge automatically.
- Buttons: `Meine Änderungen behalten`, `Aktuelle Fassung übernehmen`, or choose per field.
- Approvals and status changes are not merged. If the status moved on (`Freigegeben` already), show the current status and block the action.
- Queued offline edits that hit a conflict go to a review list: offline-sync.md §6.

## 12. Login

- Fields: `Benutzername` or `E-Mail`, `Passwort`. Set `autocomplete="username"` and `autocomplete="current-password"`. Allow paste and password managers.

```html
<form novalidate>
  <label for="user">Benutzername</label>
  <input id="user" name="user" autocomplete="username" autocapitalize="off">
  <label for="pw">Passwort</label>
  <input id="pw" name="pw" type="password" autocomplete="current-password">
  <button type="submit">Anmelden</button>
</form>
```
- Show and hide the password with a button of at least 48 px on phones. Keep its name constant (`Passwort anzeigen`) and set `aria-pressed`, or change the name, not both.
- WCAG 3.3.8 (AA): no step may depend on remembering or retyping a secret without an alternative (paste, manager, passkey, e-mail link). A distorted-text or puzzle CAPTCHA needs an alternative too.
- One-time codes: `autocomplete="one-time-code" inputmode="numeric"`.
- Error text gives no security detail. Same message and same timing for unknown user and wrong password: `Anmeldung nicht möglich. Prüfen Sie Benutzername und Passwort.` For a lock: `Zu viele Versuche. Bitte in TODO: Minuten erneut versuchen.`
- Session expiry must never drop a draft. Show a re-login layer on top of the form, then return with all input intact. Field apps keep sessions long enough for a working day or refresh them silently.
- Tenant branding on the login page uses tokens only (tokens-theming.md §3).
