# Changelog

## app-design 0.1.0 - 2026-11-06

- Plugin `app-design` angelegt, mit einem Skill `app-design` in drei Modi: Bauen, Prüfen, Texte.
- Quelle sind drei Skills unter MIT-Lizenz: `apple-design-pro` (B-Riemer/claude-skills), `ux-designer-skill` (szilu) und `ux-writing-de` (wornysek/claude-web-skills-toolkit). Für unsere Kunden neu geschrieben, zusammengeführt und auf Büro-Tools, Handy-Apps auf der Baustelle und Mandanten-Farben zugeschnitten.
- Fester Stand jeder Quelle, Zuordnung und Update-Prüfung in `SOURCES.md`, Lizenzhinweise in `NOTICE.md`.
- Das Mess-Skript aus `apple-design-pro` ist nicht dabei. Plugins hier enthalten nur Text. Der Skill beschreibt stattdessen, wie Claude mit vorhandenen Werkzeugen misst.
- Doku auf Deutsch und Englisch in `docs/app-design/README.md`.
- Eval-Suite in `evals/app-design/`, Start mit `evals/run.sh app-design`.

## klartext 0.1.1 - 2026-11-03

- Beschreibung von `quick` ohne spitze Klammern. claude.ai lehnt XML-Tags in Skill-Beschreibungen ab und meldete beim Sync zwei Warnungen. Das Verhalten der Skills ändert sich nicht.
- Doku: Einbau über die Claude-App und claude.ai (Customize > Plugins > Add marketplace) und der einmalige Befehl `claude plugin marketplace add` für das Terminal.

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
