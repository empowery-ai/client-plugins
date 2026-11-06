# States and feedback

What the user sees while waiting, when nothing is there, when something fails, and how the app reports what happened.

Load when: building any view that loads data, sends data or can fail; adding a toast, banner, confirm dialog or undo; reviewing lens 3 (states and data).

Contents: 1 The state list, 2 Response times and indicators, 3 Skeletons and spinners, 4 Pending buttons and double submit, 5 Progress for long jobs, 6 Empty states, 7 Errors, 8 Choosing inline, banner, toast or dialog, 9 Destructive actions and undo, 10 Optimistic or pessimistic updates, 11 Stale and partial data.

## 1. The state list

Every view and every data component has all of these. Build them with the happy path, not after. Review each one.

| State | What must be shown | Details |
|---|---|---|
| Loading | Skeleton or spinner after 300 ms | §2, §3 |
| Empty | What belongs here and the next action | §6 |
| Error | What failed, how to retry, input kept | §7 |
| Partial | Which part is missing | §11 |
| Success | The result and the next step | `wording-de.md` §8 |
| Offline | Offline status, what still works, what is queued | `offline-sync.md` §2 |
| No permission | Say it, name who can grant it | §6 |
| One item | Layout does not break, plural text correct (`1 Position`) | `formats-de.md` §6 |
| Many items | Pagination or virtual list, count shown | `tables-filters.md` §6 |
| Long text | Wraps or truncates with the full text reachable | `formats-de.md` §9 |

Check: for each screen, list which of the ten states exist. A missing state is Medium, a missing error state on a save action is High.

## 2. Response times and indicators

One set of thresholds for the whole skill. They are our assessment (A), common in UX practice.

| Time until the result | What to show |
|---|---|
| Press | Visible press state within 100 ms (`motion.md` §2) |
| Under 300 ms | Nothing. An indicator that flashes is worse than none. |
| From 300 ms | Skeleton for regions and lists, spinner for a button or a small area |
| Once shown | Keep it at least 300 ms, so it does not flicker |
| Over about 5 s, or job-based | Determinate progress with steps and `Abbrechen` (§5) |

- Pick by what is loading. A region or table gets a skeleton. An action (save, send) gets an inline spinner next to a status text. A whole-page blocker is rare: block only the region that loads.
- Show something useful first: load the page frame, then the data. Keep header, toolbar and navigation visible.
- Never leave a request without an outcome. Every request ends in data, an empty state or an error, within a timeout the user can see.
- Offline or slow: after the network timeout, say so (`Verbindung ist langsam`) instead of spinning forever.

## 3. Skeletons and spinners

- A skeleton matches the final layout: same columns, same row height, same positions, so nothing shifts when data arrives (`layout-navigation.md` §7).
- Skeleton colors are tokens: a step of `--color-surface-raised` on `--color-surface`. Check both themes.
- Mark the loading region with `aria-busy="true"` and remove it when done. Do not make every skeleton bar a separate announcement.
- Shimmer is optional. A static skeleton is fine. A shimmer must stop under `prefers-reduced-motion` (`motion.md` §7).

```css
.skeleton { background: var(--color-surface-raised); border-radius: var(--radius-sm); min-height: 1rem; }
@media (prefers-reduced-motion: no-preference) {
  .skeleton { animation: pulse 1.2s ease-in-out infinite; }
}
@keyframes pulse { 50% { opacity: 0.6; } }
```

- A spinner is for short, local waits: a button, a refresh icon. A spinner for a whole table is a skeleton job.
- Do not replace a skeleton with a spinner halfway. Keep the shape until the data is there.

## 4. Pending buttons and double submit

- The button keeps its label and shows the work: `Wird gespeichert …`, `Wird gesendet …`. Do not hide the text with `color: transparent`: it breaks contrast, translation and screen readers.
- Keep the width stable (`min-width`), so the layout does not jump.
- Do not use the `disabled` attribute during the request. A disabled button leaves the focus order and a keyboard user loses their place. Use `aria-disabled="true"` and ignore further activation.
- One request per press. Guard in code, and send an idempotency key so the server drops a duplicate (`offline-sync.md` §4). A double submit that creates two picking orders is Critical.
- Announce the result with a polite status region (`accessibility.md` §9), not by moving focus away.

```tsx
<button type="submit" aria-disabled={pending} onClick={(e) => pending && e.preventDefault()}>
  {pending ? "Wird gespeichert …" : "Protokoll speichern"}
</button>
```

- After success: say what happened and where the user can see it. After failure: re-enable at once, keep all input, show the reason (§7).

## 5. Progress for long jobs

Jobs over about 5 s, or any job-based work (an import, a PDF export of many protocols, a bulk approval).

- Determinate when the total is known: `Zeile 847 von 1.240`. Show named steps and the current one. Use `role="progressbar"` with `aria-valuenow` and a text label, or a native `progress` element.
- Indeterminate only when the total is truly unknown, with stage text so it does not look frozen.
- Offer `Abbrechen` when cancelling is safe, and say what happens to work already done.
- The user can leave and return. The job runs on the server, the status page shows the true state (`tables-filters.md` §11).
- Announce progress in a polite live region, throttled to steps or every 10 percent, not every tick.
- Over about 30 s: say it continues in the background and where the result will be. Tell the user in-app, for example in the runs list. No email or push is required.
- Progress never goes backward. If a step restarts, say so.

## 6. Empty states

An empty state answers three things: what belongs here, why it is empty, what to do next. Text rules and German examples per variant: `wording-de.md` §8.

| Variant | When | Action |
|---|---|---|
| First use | Nothing created yet | Create the first one (`Lieferschein anlegen`) |
| No results | A search or filter matches nothing | Name the active filters, offer `Filter zurücksetzen` |
| No access | The user lacks permission | No button; name who can grant access |
| Nothing to do | A task list is cleared | No button |
| Offline, no cache | Needs the network, nothing stored | `Erneut versuchen` |

- The next action is a button, only if the user can do it. No button for a state they cannot change.
- An empty state is not an error. Do not use the danger color.
- Illustrations are optional. Text and the next action are required. No emoji.
- The layout of the surrounding page stays intact: header, filters, toolbar.
- A zero count is explicit: `0 Aufträge`, not a blank space.

## 7. Errors

Pick the smallest scope that fits the failure.

| Scope | Use for | Pattern |
|---|---|---|
| Field | One input is invalid | Message under the field, linked with `aria-describedby`, plus a summary at the top of a long form (`forms-protocols.md` §3) |
| Region or page | A section or the whole view failed to load or save | Banner at the top of the region with a retry |
| Full page | Nothing works (server down, session gone) | Error page with the cause, `Erneut versuchen`, a way out |

Rules:
- Say what happened, why if it helps, and what to do now (`wording-de.md` §7). No blame, no codes alone.
- Never lose input. After any error, the form still holds what the user typed. This includes network loss, a 5xx, a timeout and an expired session.
- Session expired during a form: keep the draft, show a sign-in inside the page (`Sie wurden nach längerer Pause abgemeldet. Melden Sie sich neu an, um weiterzuarbeiten.`), then resume and resend. Never drop the user on a blank login with the work gone.
- A retry control on every error that can be retried: `Erneut versuchen`. Retry reuses the same idempotency key (`offline-sync.md` §4).
- Give server errors a short reference code (`Fehlercode: K7F2-94`) in text users can select and copy, and log the same code. Support finds it in seconds.
- Distinguish kinds: validation (user fixes it), conflict (someone else changed it, `offline-sync.md` §6), permission, network, server. Each kind gets its own text and action.
- Errors are not color alone: icon plus text, in `--color-danger` with the `-bg` tint (`tokens-theming.md` §6). A banner or toast may carry the severity word `Fehler` (§8); the message sentence itself never starts with `Fehler:` (`wording-de.md` §7).
- Move focus to the error summary or the first invalid field after a failed submit. Do not move focus for background errors; announce them (§8).

## 8. Choosing inline, banner, toast or dialog

Match the weight of the message to its real importance.

| Situation | Pattern |
|---|---|
| A field is wrong | Inline, next to the field |
| A decision is needed before continuing | Dialog |
| Page or region problem, persists until fixed | Banner, stays until resolved |
| Action done, nothing more to do (saved, copied) | Toast, auto-dismiss |
| Action done and the user can act on it (`Rückgängig`) | Toast with action, stays until dismissed |
| An action failed | Banner or inline for the context; if a toast, it stays until dismissed |
| Connection state, maintenance | Banner, no dismiss, disappears when resolved |
| Something happened elsewhere (new Auftrag arrived) | Badge on the nav item |

The toast rule, canonical:
- Success or info without an action: 4 to 6 s, paused while hovered or focused.
- With an action, or an error: stays until dismissed. A keyboard or screen reader user cannot reach an action in a few seconds (WCAG 2.2.1, 2.1.1).
- At most 3 stacked. Newest on top. The oldest info toast leaves first.
- Toasts live in a polite live region: `role="status"`. `role="alert"` only for an urgent error that needs interruption (`accessibility.md` §9). Do not put `role="alert"` and `aria-live="assertive"` on the same element.
- Position: Office tool, bottom left or bottom right, away from the primary action. Field app, above the sticky bottom bar, never covering the button the user just pressed.
- A toast never carries the only record of something important. The result also shows in the screen (the saved row, the status badge).

Banners: at most one or two at once. Dismissible only when it is information, not a state. An offline banner or a `Senden fehlgeschlagen` banner clears when the cause is gone, not when clicked away.

Dialogs: only for decisions. Never information alone, never on top of another dialog (`layout-navigation.md` §4).

Severity is shown with icon plus word plus color: `Fehler`, `Warnung`, `Hinweis`, `Erfolg`. The word can be visually hidden in a toast, but exists for screen readers.

## 9. Destructive actions and undo

Prefer undo over a confirm. A confirm dialog on every delete teaches users to click through it.

| Action | Pattern |
|---|---|
| Reversible (archive, delete to trash, remove a row from a draft) | Do it at once, toast with `Rückgängig`; the item sits in `Papierkorb` for a while |
| Hard to reverse (reject an approval, discard a draft) | Confirm dialog naming the object and consequences |
| Irreversible (delete permanently, post a final Lieferschein, send to an outside party) | Confirm dialog; for the highest stakes, type the name to confirm (A) |
| Bulk destructive | Dialog with the count: `3 Aufträge löschen?` |

- The undo must work as long as the toast is visible. The toast with action stays until dismissed (§8). Better: also a trash view for days (A).
- Confirm dialog text per `wording-de.md` §8: title as a question with the object, consequences in one sentence, buttons that repeat the action (`Löschen`, `Abbrechen`), never `Ja` and `Nein`.
- In a confirm for a destructive action, focus starts on the safe button (`Abbrechen`). Enter must not delete by accident.
- The danger color appears in the confirm button, not on every row action.
- A disabled action always has its reason in text (`Freigeben ist erst möglich, wenn alle Pflichtfelder ausgefüllt sind.`).
- Never auto-confirm, never hide the consequence in a tooltip.

## 10. Optimistic or pessimistic updates

| Update | Strategy |
|---|---|
| Small, reversible, personal (a note, a tag, a column setting, a favorite filter) | Optimistic: show at once, roll back with an error toast on failure |
| Approval, rejection, status change with consequences | Pessimistic: show `Wird gesendet …` and wait for the server |
| Create an order, a picking order, a protocol submit | Pessimistic with a visible pending state and an idempotency key |
| Delete | Pessimistic, or undo-based (§9) |
| Anything needing server validation | Pessimistic |

- Optimistic needs a rollback path, a failure message and a visible trace (`Gespeichert, 14:32 Uhr`). Showing success and silently losing the data is Critical.
- Pessimistic shows what is happening in place: the row or button shows `Wird gesendet …`, others stay usable.
- Offline is separate. Work saved to the device outbox is neither optimistic nor done. It shows `Auf dem Gerät gespeichert` until the server confirms (`offline-sync.md` §1, §2).
- If an optimistic update has no server confirmation within a few seconds, say so instead of leaving a false state.

## 11. Stale and partial data

- Data that may be old says when it is from: `Stand: 14:30 Uhr`, with a refresh button next to it. Cached data is visibly different from live data by text, not by dimming alone.
- Refresh on a clear rule: manual button, on return to the tab, on reconnect. Auto-refresh must not move rows under the user's pointer: apply it when the user is idle, or show `Neue Daten verfügbar` with a button.
- Partial results are marked: `Teilergebnis, 2 von 3 Quellen geladen` with `Erneut laden`. A total that silently excludes a failed source is wrong data.
- Never show outdated data as if it were current. Numbers that drive decisions (stock, price) show their age.
- After reconnect, refresh the cached view and tell the user if anything changed under them.
