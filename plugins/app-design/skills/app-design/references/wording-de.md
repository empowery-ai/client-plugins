# German UI wording

Rules and German examples for every text in the interface. Rules in English, examples
in German. Examples use Sie; du forms follow the same rules.

Load when: Wording mode, review lens 6, or any Build task that adds visible text.

Contents: 1 Process · 2 Form of address · 3 Inclusive language · 4 Tone · 5 Buttons
and links · 6 Labels, hints, placeholders · 7 Error messages · 8 Empty states,
confirmations, success · 9 Status vocabulary · 10 Table and filter wording · 11 Field
and voice wording · 12 Plain language · 13 Glossary · 14 Output format

## 1. Process

1. Understand the moment: who reads it, on which device, what they do next. A
   dispatcher at a desk and a fitter on a ladder need different lengths.
2. Read the recorded decisions: form of address (§2), gender style (§3), glossary
   (§13). If one is missing, ask once and suggest recording the answer in the project
   (CLAUDE.md, glossary file or tenant settings).
3. Collect the facts. Never invent limits, deadlines, prices or legal claims. Write a
   visible `TODO:` instead: `Erlaubt sind TODO: Limit klären MB.`
4. Write the meaning, not the words of an English draft.
5. Check variables, plurals, long words, numbers and dates with `formats-de.md`.
6. Report every changed string in the format of §14.

## 2. Form of address: du or Sie

A setting per app, and per tenant in a white-label core. No global default. Record it
next to the glossary.

| | Sie | du |
|---|---|---|
| Often fits | Office tools, approvals, customer-facing screens | Field crews, teams that use du internally |
| Instruction | `Geben Sie die Menge ein.` | `Gib die Menge ein.` |
| Possessive | `Ihre Aufträge` | `deine Aufträge` |
| Question | `Möchten Sie den Entwurf verwerfen?` | `Möchtest du den Entwurf verwerfen?` |

- Sie, Ihr, Ihnen, Ihre are always capitalized. du, dein, dich are lowercase in UI.
- Never mix both on one screen, in one flow or in one tenant. Check: search the
  message file for `dein`, `Ihr`, ` du ` and ` Sie `.
- Buttons in the infinitive (§5) fit both forms, so a switch changes only sentences.
- A core with du and Sie tenants keeps both variants in the message files
  (`formats-de.md` §10), never a runtime search and replace.

## 3. Inclusive language

German person nouns carry gender (`der Monteur`, `die Monteurin`). Pick one style per
tenant, record it, use it everywhere.

1. Direct address first: `Sie haben 3 offene Protokolle.` instead of
   `Der Benutzer hat …`.
2. Neutral forms: `Team`, `Person`, `Mitarbeitende`, `Kundschaft`, `Ansprechperson`.
   Role names (`Disposition`, `Lager`, `Bauleitung`) are often neutral already.
3. Pair forms in running text only: `Monteurinnen und Monteure`. Too long for labels.
4. Gender characters (`Monteur*innen`) only when the tenant asks. Then one character,
   never mixed with the generic masculine.

Caution: screen readers handle gender characters differently by product and setting;
some read the character aloud, some pause. Neutral forms avoid the question.

## 4. Tone for trades and office

The users are at work. Text is factual, short and calm.

- Sachlich: what is, what happened, what to do. No humor, no `Hoppla`, no `Super!`,
  no exclamation marks, no capitals for emphasis, no emoji.
- No blame: `Die Menge fehlt.`, not `Sie haben die Menge vergessen.`
- `bitte` at most once, where you ask the user to act again. On every line it reads
  like a form letter. One `leider` is fine when the system failed; no chains.
- System statements in neutral voice: `Der Import ist abgeschlossen.` Use `wir` only
  if the tenant writes as a company toward its own customers.
- The first five words carry the point. Details follow or sit behind a link.

## 5. Buttons and links

- Infinitive plus object: `Auftrag freigeben`, `Lieferschein drucken`,
  `Importlauf starten`. Not `OK`, `Absenden`, `Ja`, `Hier klicken`.
- Sentence-style capitalization: `Protokoll senden`, never `Protokoll Senden`.
  German nouns stay capitalized. No English Title Case.
- Dialog buttons repeat the title's action: `Entwurf verwerfen?` with `Abbrechen` and
  `Entwurf verwerfen`.
- Link text names the destination: `Fehlerbericht herunterladen (CSV)`. Never `hier`
  or `mehr` alone. Repeated row links get the row in the accessible name
  (`aria-label="Auftrag 4711 öffnen"`).
- Pending label in place: `Wird gespeichert …`, `Wird gesendet …`.
- Field app buttons: one or two words, verb first: `Senden`, `Foto aufnehmen`,
  `Unterschreiben`. The screen title supplies the object.
- Same action, same word, across the app:

| Word | Means | Not to be confused with |
|---|---|---|
| löschen | Gone for good | entfernen: out of this list, the item still exists |
| speichern | Keep changes, nobody is notified | senden, einreichen: hand over to someone |
| einreichen | Submit for approval | freigeben: the approver's action |
| freigeben, ablehnen | Approver decides | bestätigen: acknowledge only |
| verwerfen | Throw away unsaved changes | abbrechen: close, nothing is lost |
| importieren | Read a file into the system | hochladen: attach a file as it is |
| übernehmen | Take proposed values into the record | speichern |

Pass: no two labels use different verbs for one action; no button reads `OK` or `Ja`.

## 6. Labels, hints and placeholders

- Labels are short nouns: `Kunde`, `Lieferdatum`, `Artikelnummer`.
- Units go in the label: `Fläche (m²)`, `Länge (mm)`, `Menge (Stk.)`.
- Hints sit under the label, before any error:
  `8 Ziffern, oben rechts auf dem Lieferschein.`
- Placeholders show an example only (`z. B. 12,5`), never the label or required text.
- Optional fields: `(optional)` in the label. One convention per app
  (`forms-protocols.md` §1).
- Explain a sensitive question in one line:
  `Die Handynummer nutzt das Lager nur für Rückfragen zur Lieferung.`
- Checkboxes state the positive case: `Kunde war bei der Abnahme anwesend`.
- Section headings name the purpose: `Mängel`, `Verbautes Material`, `Unterschriften`.
- Photo fields name subject and count: `Fotos der fertigen Fläche (mindestens 2)`.
- Signature fields name person and role, with a printed name beside them:
  `Unterschrift Auftraggeber`, `Name in Druckbuchstaben`.

## 7. Error messages

Formula: what happened, why (only if it helps), what to do now. No code alone, no
`Fehler:` prefix, no exclamation mark, no blame. Say only what is true: write
`Ihre Eingaben sind noch da` only if the app really kept them.

| Situation | Generic | Specific |
|---|---|---|
| Required field | Pflichtfeld | Geben Sie die Fläche in m² ein. |
| Wrong format | Ungültige Eingabe | Geben Sie die Menge als Zahl ein, z. B. 12,5. |
| Import row | Zeile 17: Fehler | Zeile 17 übersprungen: Artikelnummer fehlt. Ergänzen Sie sie und importieren Sie die fehlerhaften Zeilen erneut. |
| Approval conflict | Konflikt (409) | {name} hat diesen Auftrag um 14:12 Uhr geändert. Laden Sie den aktuellen Stand und prüfen Sie Ihre Änderungen. |
| Voice not understood | Spracherkennung fehlgeschlagen | Das war nicht zu verstehen. Sprechen Sie noch einmal oder tippen Sie die Position ein. |
| Photo too large after resizing | Datei zu groß | Das Foto ist auch verkleinert noch 14 MB groß, erlaubt sind 10 MB. Nehmen Sie es neu auf. |
| Protocol not saved | Speichern fehlgeschlagen | Das Protokoll wurde nicht gespeichert. Ihre Eingaben sind noch da. Versuchen Sie es erneut. |
| Picking order not sent | Netzwerkfehler | Der Kommissionierauftrag ist noch nicht im Lager. Er wird gesendet, sobald wieder Netz da ist. |
| Server error | Interner Serverfehler | Der Server antwortet gerade nicht. Versuchen Sie es in einer Minute erneut. Bleibt das Problem, nennen Sie dem Support den Code A7F3-26. |
| Session expired | Nicht autorisiert | Sie wurden nach längerer Pause abgemeldet. Melden Sie sich neu an, um weiterzuarbeiten. |
| No permission | Zugriff verweigert | Aufträge freigeben darf nur die Disposition. Wenden Sie sich an Ihre Teamleitung. |
| Login | Benutzer nicht gefunden | Anmeldung nicht möglich. Prüfen Sie Benutzername und Passwort. |

- Login errors never reveal whether an account exists. Field errors sit at the
  field; long forms add a linked summary at the top (`forms-protocols.md` §3).
- Reference codes are short and readable aloud on the phone: no `0`/`O` or `1`/`l`.
- The limits and times above are placeholders. Use the app's real values or `TODO:`.

## 8. Empty states, confirmations, success

Empty states say what the area holds, why it is empty and what to do:

| Variant | Headline | Body | Action |
|---|---|---|---|
| First use | Noch keine Importläufe | Hier sehen Sie jeden Preislisten-Import mit Status und Fehlerzeilen. | Datei importieren |
| No results | Keine Aufträge für „Offen, KW 45“ | Ändern Sie die Filter oder setzen Sie sie zurück. | Filter zurücksetzen |
| No access | Lieferscheine sieht nur das Lager | Wenden Sie sich an Ihre Teamleitung, wenn Sie Zugriff brauchen. | (none) |
| Nothing to do | Alle Protokolle sind eingereicht | Neue Aufträge erscheinen hier automatisch. | (none) |
| Offline, nothing cached | Keine Daten auf diesem Gerät | Die Liste lädt, sobald wieder Netz da ist. | Erneut versuchen |

Confirmation dialogs, only for irreversible actions (`states-feedback.md` §9):
- Title is a question with the object: `Lieferschein 2026-0815 löschen?`
- Body names the consequence in active voice: `Der Lieferschein und seine 14
  Positionen werden gelöscht. Das lässt sich nicht rückgängig machen.`
- Buttons repeat the action: `Abbrechen`, `Lieferschein löschen`. Never `Ja` and
  `Nein`, never `Sind Sie sicher?` as the whole question.

Success names the result and the next step, if any:
- `Auftrag 4711 freigegeben. Das Lager sieht ihn jetzt in der Kommissionierliste.`
- `Importlauf abgeschlossen: 1.204 Zeilen übernommen, 3 übersprungen.`
- Toasts: one sentence, at most one action (`Rückgängig`, `Anzeigen`). No
  celebration for routine work.

## 9. Status vocabulary

One word per state, the same in badges, filters, toasts and exports. Badges always
carry the text; color and icon are extra, never the only signal (WCAG 1.4.1).

| Domain | States, in order |
|---|---|
| Approval | Entwurf · Eingereicht · In Prüfung · Freigegeben · Abgelehnt |
| Import | Wartet · Läuft · Abgeschlossen · Mit Fehlern abgeschlossen · Fehlgeschlagen |
| Sync (field app) | Auf dem Gerät gespeichert · Wird gesendet · Gesendet · Senden fehlgeschlagen · Konflikt |
| Protocol section | Offen · In Arbeit · Vollständig · Fehlerhaft |
| Picking order | Offen · In Kommissionierung · Bereitgestellt · Ausgeliefert |

- No synonyms on other screens (`Genehmigt` beside `Freigegeben`, `Erledigt` beside
  `Abgeschlossen`). Check: grep the message file for each status word and synonyms.
- `Gesendet` only after the server confirmed receipt (`offline-sync.md` §2).
- `Abgelehnt` comes with reason and decider: `Abgelehnt von {name}: Mengen prüfen`.

## 10. Table and filter wording

- Column headers are nouns, with the unit when the column shares one:
  `Menge (Stk.)`, `Fläche (m²)`, `Preis (€)`, `Lieferdatum`.
- Filter labels name the field: `Status`, `Lieferant`, `Zeitraum`. Options use §9.
- Result count with the noun: `124 Aufträge`, `1 Auftrag`, `Keine Aufträge`. With
  filters: `124 von 3.580 Aufträgen`.
- Reset is always `Filter zurücksetzen`. A chip's remove button is named
  `Filter Status: Offen entfernen`.
- Zero results name the active filters and offer reset or a wider time range (§8).
- Search: label `Suche`, scope as example: `z. B. Auftragsnummer oder Kunde`.
- Bulk bar: `3 Aufträge ausgewählt`; actions carry the count: `3 Aufträge freigeben`.
- Stale data: `Stand: 14:30 Uhr` with the action `Aktualisieren`.

## 11. Field and voice wording

- Screen titles name the task: `Abnahme`, `Material anfordern`, `Fotos`.
- Instructions start with the verb: `Fläche fotografieren`,
  `Kunde unterschreiben lassen`.
- Voice prompt: `Sprechen Sie den Materialbedarf ein.` Once, an example:
  `z. B. „drei Kupferrohre 15 Millimeter“`.
- Voice states as visible words: `Bereit`, `Hört zu …`, `Wird verarbeitet …`,
  `Nicht verstanden`.
- Confirm what was understood before sending:
  `Verstanden: 3 × Kupferrohr 15 mm. Stimmt das?` with `Senden` and `Korrigieren`.
  Several positions appear as an editable list, not as one sentence.
- Offline text matches what the app really does:
  - Queues: `Offline. Das Protokoll wird auf dem Gerät gespeichert und gesendet,
    sobald wieder Netz da ist.`
  - Cannot queue: `Offline. Senden geht erst wieder mit Netz. Ihre Eingaben bleiben
    auf dieser Seite.`
- Counters: `3 von 5 Fotos`, `12 Positionen erfasst`.

## 12. Plain language

Bring the verb forward, one statement per sentence, active voice.

| Noun style | Plain |
|---|---|
| Die Freigabe des Auftrags erfolgt durch die Disposition. | Die Disposition gibt den Auftrag frei. |
| Die Übermittlung an das Lager ist erfolgt. | Das Lager hat den Auftrag erhalten. |
| Es ist zu beachten, dass unvollständige Protokolle nicht eingereicht werden können. | Füllen Sie alle Pflichtabschnitte aus, dann können Sie das Protokoll einreichen. |
| Eine Überprüfung der Mengen ist vorzunehmen. | Prüfen Sie die Mengen. |
| zwecks Erfassung der Mängel | um die Mängel zu erfassen |
| in Bezug auf den Lieferschein | zum Lieferschein |

- Split sentences over about 20 words (A). Keep the domain terms users really
  use (§13).

## 13. Glossary

The glossary lives per app or per tenant, beside form of address and gender style.
One term per concept.

| Use | Avoid | Note |
|---|---|---|
| anmelden, abmelden | einloggen, ausloggen | `Login` is a tenant style choice; default anmelden |
| Konto or Account | both mixed | Pick one |
| E-Mail-Adresse | Email-Adresse, eMail | |
| Einstellungen | Settings, Konfiguration | |
| hochladen, herunterladen | uploaden, downloaden | |
| Passwort or Kennwort | both mixed | Pick one |

Domain terms (adjust meaning per tenant, keep one term per concept):

| Term | Meaning in the app |
|---|---|
| Auftrag | Customer order the firm executes; not `Bestellung` (purchase from a supplier) |
| Lieferschein | Delivery note that travels with the goods |
| Kommission | Customer or site reference under which goods are picked and delivered |
| Kommissionierauftrag | Picking order for the warehouse |
| Abnahmeprotokoll | Record of the customer's acceptance of finished work |
| Montageprotokoll | Record of an installation: material, steps, tests |
| Aufmaß | Quantities measured on site, the basis for billing |
| Charge | Production batch; matters where shade or lot must match |
| Freigabe | Approval by an authorized role |
| Entwurf | Saved, not yet submitted |

Check: no screen uses an avoided term; each domain term means the same everywhere.

## 14. Output format

Wording mode and wording findings use one table. It matches SKILL.md §8.

```markdown
| Location | Before | After | Rule |
|---|---|---|---|
| `Abnahme.tsx:42` | Fehler! Ungültige Eingabe. | Geben Sie die Fläche in m² ein, z. B. 12,5. | `wording-de.md` §7 |
| `Import.tsx:88` (button) | OK | Importlauf starten | `wording-de.md` §5 |
| `AuftragListe.tsx:17` | {kunde}s Aufträge | Aufträge von {kunde} | `formats-de.md` §7 |

Form of address: Sie · Gender style: direct address and neutral forms ·
Open TODOs: `TODO: Limit klären` in `FotoFeld.tsx:31`
```

- Location: file and line, or screen and element. Group repeated fixes into one
  row with all locations.
- Rule: cite `file.md §N`, plus the WCAG criterion where text affects accessibility.
- In a Review report, wording findings use this table under lens 6.
