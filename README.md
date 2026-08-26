# client-plugins

Der Plugin-Marktplatz von empowery für Kunden.

## Was das ist

Hier liegt ein Plugin für Claude Code: `empowery-starter`.

Das Plugin bringt zwei Dinge mit:

1. **Antwortstil ELI5.** Claude antwortet in kurzen Sätzen. Ein Gedanke pro Satz. Am Ende ein klarer nächster Schritt.
2. **Skill `session-context`.** Er hilft, wenn Kontext zwischen zwei Arbeits-Sessions verloren geht.

## Für wen

Für Menschen in Kundenprojekten von empowery, die mit Claude Code arbeiten und kein KI-Vokabular brauchen wollen.

## Mindestversion

Claude Code **2.1.232** oder neuer.

Prüfen:

```bash
claude --version
```

Ist die Zahl kleiner, erst Claude Code aktualisieren. Sonst funktioniert der Antwortstil nicht wie beschrieben.

## Einbau

Ein Befehl:

```bash
claude plugin install empowery-starter@empowery-client --scope local
```

`--scope local` heißt: das Plugin gilt nur in diesem einen Projektordner.

Ohne `--scope local` gilt der Antwortstil in **allen** Projekten des Nutzers. Auch in privaten. Das will fast niemand.

Danach Claude Code komplett neu starten. Also das Programm schließen und wieder öffnen.
`/clear` reicht nicht.

## Der Stil aktiviert sich selbst

Die Datei `ELI5.md` trägt `force-for-plugin: true`.

Das heißt: der Stil schaltet sich beim Start selbst ein. Er überschreibt dabei eine eigene Stil-Wahl des Nutzers.

Das ist Absicht. Der Kunde soll nichts einstellen müssen, damit es funktioniert.

Wer den Stil von Hand wählen oder abwählen will, macht das über `/config` unter "Output style". Zurück auf den normalen Stil: `/config` und dann `Default`.
Alternativ setzt man das Feld `outputStyle` in einer Settings-Datei, zum Beispiel in `.claude/settings.local.json`:

```json
{ "outputStyle": "ELI5" }
```

Eine solche Wahl greift aber erst nach einem vollständigen Neustart von Claude Code. Und solange dieses Plugin aktiv ist, gewinnt das Plugin.

## Abschalten (Kill-Switch)

```bash
claude plugin disable empowery-starter@empowery-client --scope local
```

Danach Claude Code neu starten.

**Warum ein Disable im User-Scope nicht reicht:** Ist das Plugin in der Projektdatei `.claude/settings.json` aktiviert, dann gewinnt diese Projektdatei. Ein Disable im User-Scope wird davon überstimmt. Das Plugin bleibt an.

Darum immer den Scope treffen, in dem es eingeschaltet wurde. Bei Kunden ist das meistens das Projekt.

**Notfall.** Wenn nichts hilft, einen ausdrücklichen `false`-Eintrag in `.claude/settings.local.json` setzen:

```json
{
  "enabledPlugins": {
    "empowery-starter@empowery-client": false
  }
}
```

Diese Datei liegt in der Rangfolge über der Projektdatei. Danach `/reload-plugins` ausführen.

## Offboarding

Wenn ein Engagement endet, vier Schritte:

1. Plugin entfernen:

   ```bash
   claude plugin uninstall empowery-starter@empowery-client
   ```

2. Marktplatz entfernen:

   ```bash
   claude plugin marketplace remove empowery-client
   ```

3. Den `extraKnownMarketplaces`-Block aus den Settings im Kunden-Repo löschen. Sonst kommt der Marktplatz beim nächsten Start zurück.

4. Optional: den Antwortstil behalten. Dazu die Datei `ELI5.md` als Kopie nach `~/.claude/output-styles/ELI5.md` legen. Der Ordner heißt `output-styles`. Der Stil ist dann eine eigene Datei des Kunden und hängt nicht mehr an empowery.

Danach Claude Code neu starten.

## Release-Regeln

`main` ist der Ausliefer-Zeitpunkt. Nicht der Arbeitsstand.

Mit `autoUpdate: true` erreicht **jeder** Push auf `main` alle Kunden. Es gibt keine Testphase dazwischen.

Daraus folgen drei feste Regeln:

- Entwicklung läuft nur auf Branches. Nie direkt auf `main`.
- Jeder Release bekommt einen git-Tag.
- Die Versionsnummer in `plugins/empowery-starter/.claude-plugin/plugin.json` ist die einzige kanonische Quelle. `marketplace.json` und `CHANGELOG.md` folgen ihr.

**Letzte bekannt funktionierende Version: 0.1.0.**

Wenn ein Kunde nach einem Update ein Problem meldet, ist das die Version, auf die zurückgesetzt wird.

## Support

Mail an db@empowery.io. Bitte drei Dinge mitschicken:

1. Die Ausgabe von `claude --version`.
2. Was du getippt hast.
3. Was passiert ist.
