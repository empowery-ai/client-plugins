# Changelog

## klartext 0.1.0 - 2026-10-29

- Plugin `klartext` angelegt, mit zwei Skills: `wait-what` und `quick`. Beide tragen `disable-model-invocation: true`. Claude startet sie also nie von selbst.
- Quelle sind zwei interne Skills von empowery. Für Kunden umgeschrieben: neutral formuliert, ohne interne Quellen, mit Sprachregel (antwortet in der Sprache des Nutzers).
- Neu gegenüber der Quelle: Die Skills schreiben ß oder ss so, wie der Nutzer es tut. Schweizer Kunden schreiben ss.
- Doku auf Deutsch und Englisch in `docs/klartext/README.md`.
- Eval-Suite für `claude plugin eval` in `evals/klartext/`, Start mit `evals/run.sh klartext`.

## empowery-starter 0.1.0 - 2026-08-26

Erste Version. Alle Doku-Fakten in diesem Repo wurden am 2026-08-26 gegen die laufende Claude-Code-Version geprüft.

- Marktplatz `empowery-client` angelegt.
- Plugin `empowery-starter` angelegt.
- Antwortstil `ELI5` übernommen. Kanonische Quelle ist ab jetzt diese Datei hier im Repo, nicht mehr `client-workspace-template`. Ergänzt gegenüber der Vorlage: `force-for-plugin: true`.
- Skill `session-context` angelegt.
- CI-Schranke `inventory.yml` angelegt. Sie erlaubt im Plugin-Ordner nur `.claude-plugin/`, `output-styles/` und `skills/`.
