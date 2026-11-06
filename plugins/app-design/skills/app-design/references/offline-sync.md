# Offline and Sync

Work that must survive a weak or missing network. The rule: the user's input is safe, the status is honest, and nothing is sent twice.

Load when: building or reviewing offline behavior, a sync status, an outbox of unsent items, retries, uploads of photos, or edit conflicts.

Contents: 1 What works offline, 2 Connection and sync status, 3 The outbox, 4 Retries and idempotency, 5 Browser limits, 6 Conflicts, 7 Uploads on a weak network, 8 Testing offline.

Status: browser facts carry "as of 2026-11, re-check". Numbers marked (A) are our own assessment. The Field app is the main user. The Office tool needs only §2 (banner on lost connection), §4 and §6.

## 1. What works offline

Decide per action. Queue an action only if the user does not need the result to go on, the server can accept it late, and a conflict is unlikely.

| Action | Offline | Rule |
|---|---|---|
| View assigned Aufträge, Artikelstamm, form schemas | Yes, from cache | Show `Stand: 14:32 Uhr` (states-feedback.md §11) |
| Fill in a protocol, take photos, sign | Yes, as draft and then queued | Status words in §2 |
| Send a Kommissionierauftrag | Queued | Honest text: `Auf dem Gerät gespeichert. Das Lager sieht den Auftrag nach dem Senden.` |
| Search | Only in cached data | Label it: `Suche nur in geladenen Daten` |
| Approve, reject, release (Freigabe) | No | Needs the server (states-feedback.md §10). Show `Nur online möglich` with the reason |
| Delete a server record | No | Same |
| First login | No | Needs the network once. The session is then kept |

- Decide what is cached before the field day: today's Aufträge for this user, the article catalog (voice and scan matching), form schemas with their versions. Fill the cache at login and on `online`. Show what is available offline.
- If the product decides on an exception (queue an approval), record it in the project notes and treat the action as a conflict candidate (§6).
- Disabled-because-offline controls explain themselves. A gray button with no reason is a defect.

## 2. Connection and sync status

Two separate facts: the connection, and the sync state of each item.

- `navigator.onLine` is only a hint. `false` is reliable, `true` means only that a network interface exists. Confirm with a small request to a health endpoint and a timeout.
- Treat a request that takes longer than about 5 s as weak connection (A).
- Show a persistent one-line banner, not a toast, because it is a state. Use `role="status"`. Texts:
  - `Offline. Änderungen werden auf dem Gerät gespeichert.`
  - `Schwache Verbindung. Senden dauert länger.`
  - `Zuletzt synchronisiert: 14:32 Uhr`
- Show the banner only after 2 failed probes or about 3 s of confirmed loss (A), so a short dip does not flicker.
- Pending count in the header, as text: `3 offen`. Tapping it opens the outbox list.
- Per item, status words from wording-de.md §9: `Auf dem Gerät gespeichert`, `Wird gesendet`, `Gesendet`, `Senden fehlgeschlagen`, `Konflikt` (§6). Add an icon, never color alone. A failed item shows the reason and `Erneut senden`.
- Offer `Jetzt synchronisieren` (48 px). While running it reads `Synchronisiert …` and stays focusable.
- No toast per item. When all is sent, one status line for 4 to 6 s: `Alles gesendet.`
- Signing out with unsent items: never delete them. Say: `3 Einträge sind noch nicht gesendet. Sie werden nach der nächsten Anmeldung gesendet.`

## 3. The outbox

The outbox is the list of local changes not yet confirmed by the server.

- Persist it in IndexedDB. `localStorage` is small (about 5 MB, as of 2026-11, re-check), synchronous and cannot hold photos.
- Item fields: client id (UUID), type, payload, user, created time, attempts, next attempt time, status, last error, base version (for conflicts), schema version. Photos are Blobs in a separate store, referenced by id.
- Survive reload, tab close and app update. Migrate old items when the schema version changes. Never drop an item because it is old.
- Client-generated ids for new records make the order of sending independent: a photo can arrive before its protocol and still attach. Send small text data first, photos after.
- Process one item at a time per record, several records in parallel (2 at a time on a weak network, A).
- Remove an item only after the server confirms success (2xx with the record id). Then free its photo Blobs.
- Request persistent storage with `navigator.storage.persist()` and check the answer. Check `navigator.storage.estimate()`. Warn when free space is low (A: under about 50 MB): `Speicher auf dem Gerät wird knapp. Bitte Einträge senden.` Never delete items silently to make room.
- Budget for photos: a resized photo is a few hundred KB (field-use.md §6). A day of 100 photos is tens of MB. Test with that load.
- A queued item can be opened read-only. Until sending starts, `Zurückziehen` returns it to `Entwurf`.

## 4. Retries and idempotency

A timeout means the outcome is unknown. The request may have worked. So every retry must be safe.

- Create a client id per submission when the form opens or the action is first made (`crypto.randomUUID()`). Store it with the outbox item. Send it as `Idempotency-Key` (header or field). Reuse it on every retry. Never make a new key for a retry.
- Server rule (state it in the API spec): a repeated key returns the first result and creates nothing new. Test it (§8).
- Retry on network errors, timeouts and 5xx. Do not give up for network reasons only.
- Backoff with jitter and a cap (A): wait random(0, min(60 s, 2 s x 2^attempt)). Honor `Retry-After`. Also try at once on `online`, on `visibilitychange` to visible, and on manual sync.
- Do not retry blindly on client errors:

| Response | Action |
|---|---|
| 400, 422 | Stop. Status `Senden fehlgeschlagen`, show the field errors, let the user fix |
| 401 | Pause. Ask for re-login, keep the queue, resume afterwards |
| 403 | Stop. Say the user lacks permission |
| 409 | Conflict (§6) |
| 413 | Resize the file again or tell the user |
| 5xx, network, timeout | Retry with backoff |

- No silent resubmit. Tell the user when a retry happens: `Senden dauert länger. Ihre Eingabe ist gesichert und wird erneut gesendet.`
- UI guard against double press is separate (forms-protocols.md §4). Both are needed.

```js
function nextDelayMs(attempt) {
  const cap = 60_000, base = 2_000;
  return Math.random() * Math.min(cap, base * 2 ** attempt);
}
```

## 5. Browser limits

As of 2026-11, re-check each point before you rely on it.

- Background Sync is not available in Safari on iOS or in Firefox. Do not build on it. Sync when the app opens, on `visibilitychange` to visible, on `online`, and on a timer while the app is in the foreground.
- A service worker can be stopped at any time and cannot run when the app is closed. Use it for the app shell cache (so the app opens offline), not as the only sender.
- Tell users plainly that unsent items go out the next time the app is open: the pending count (§2) shows it.
- Storage can be cleared: low disk, a user clearing site data, or a browser that removes data of sites not used for a while. Treat the outbox as precious, show the persistent-storage result, and encourage sending at the end of the day.
- A Home Screen web app and the same site in a browser tab can have separate storage on iOS. Tell fitters which one to use, and test that one.
- Update the app only when it is safe: show `Neue Version verfügbar` and reload on the user's action, after the outbox and drafts are on disk. Never reload in the middle of an open protocol.

## 6. Conflicts

A conflict is a queued change that meets a newer server version. It is not a failure.

- Send the base version or ETag with every update (`If-Match`). Store the base snapshot with the outbox item. The server answers 409 on mismatch.
- The item gets the status `Konflikt`, not `Senden fehlgeschlagen`. Show a list `Konflikte (2)` with what, which record, and when.
- The review screen uses the layout of forms-protocols.md §11: per field `Ihr Wert` against `Aktueller Wert`, a choice per field, and `Meine Änderungen behalten` or `Aktuelle Fassung übernehmen`.
- Three-way merge: a field changed only by the user, or only on the server, merges without asking. Only fields changed on both sides need a decision.
- Business conflicts always need a human: stock already moved, order already released, record deleted. Text example: `Dieser Auftrag wurde inzwischen gelöscht.` Offer `Als neuen Entwurf speichern`.
- Never overwrite silently, in either direction. Keep the losing version until the user decides.
- New records and photos rarely conflict, because they have new ids and only add data.

## 7. Uploads on a weak network

- Resize first (field-use.md §6). Most photos are then small enough for one request per file. Use chunked or resumable upload for large files (video, big PDFs): chunks of about 1 to 5 MB (A), resumed from the last confirmed chunk.
- Show progress per file with `<progress>` and text: `Foto 2 von 5: 60 %`. Throttle live-region announcements to start, failure and finish.
- Retry per file with the backoff of §4. One failed file does not block the others or the text data of the protocol.
- The protocol stays usable during upload. The upload manager lives at app level, not in the component, so leaving the screen does not stop it.
- A protocol item stays `Wird gesendet` until all required parts arrived. Show the part count: `2 von 5 Fotos gesendet`.
- Set a timeout that scales with file size. A timeout is an unknown outcome: retry with the same key (§4). The server checks the size or a checksum before it confirms.
- Allow `Abbrechen` for a running upload. Cancelling keeps the local copy.
- Do not depend on the Network Information API to decide quality. It exists in Chromium only.

## 8. Testing offline

Use DevTools network presets `Offline` and `Slow 4G` (names as of 2026-11), then repeat key steps on a real phone in airplane mode. Method and logging: measuring.md §10.

| Step | Pass |
|---|---|
| Open a protocol while Offline, app shell and data cached | Opens, `Stand:` time shown, banner visible |
| Go Offline while typing | No input lost, banner appears, no error dialog |
| Go Offline during submit | Item `Auf dem Gerät gespeichert`, no spinner forever, no duplicate |
| Reload with a pending queue | Queue and drafts intact, pending count right |
| Slow 4G upload of 5 photos | Progress per file, form usable, no double send |
| Close the tab mid-upload and reopen | Upload resumes, server holds each photo once |
| Server returns 5xx once, then 200 | Retry with the same key, exactly one record |
| Same record edited on two devices | Second save lands in `Konflikt`, nothing lost |
| Session expires while items are queued | Re-login, queue then sends, nothing lost |
| Low storage (small quota or full disk) | Warning shown, no silent deletion |

Verify the server side: count the records after each retry test. A passing UI with duplicate rows on the server is a Critical finding (review-procedure.md §11).
