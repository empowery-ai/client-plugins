# app-design

[Deutsch](#deutsch) · [English](#english)

## Deutsch

Ein Skill für die Oberfläche von Web-Apps in Betrieben. Er hilft Claude in drei
Lagen:

| Modus | Wann | Was Claude tut |
|-------|------|----------------|
| Bauen | Du willst einen neuen Screen oder ein neues Bauteil. | Claude legt zuerst Farben und Größen als Variablen an, dann Layout, Zustände und Texte. |
| Prüfen | Du hast einen Screen oder Code und willst wissen, was schlecht ist. | Claude prüft in fester Reihenfolge, misst Kontrast und Größen, ordnet nach Schwere und schlägt Lösungen vor. |
| Texte | Du brauchst Knöpfe, Fehlermeldungen oder leere Zustände auf Deutsch. | Claude schreibt kurze, klare deutsche Texte: du oder Sie, Knöpfe, die sagen, was passiert, Zahlen und Daten im deutschen Format. |

Claude wählt den Skill selbst, wenn es um die Oberfläche einer Web-App geht. Du
kannst ihn auch direkt aufrufen: `/app-design:app-design`.

### Für welche Apps

- **Büro-Tools im Browser:** dichte Tabellen, Filter, Freigaben, helles und dunkles Design.
- **Handy-Apps auf der Baustelle:** eine Hand, Handschuhe, Sonne, schwaches Netz, Spracheingabe, Fotos.
- **Eine Basis für viele Mandanten:** jede Firma bekommt ihre eigenen Farben und ihr Logo über ein paar Variablen.

Nicht gedacht für native iPhone- oder Android-Apps (Swift, Kotlin) und nicht für
Werbe-Seiten.

### Einbau

Wie bei den anderen Plugins dieses Marktplatzes:

```bash
claude plugin install app-design@empowery-client --scope local
```

In der Claude-App oder auf claude.ai: **Customize** > **Plugins** > Marktplatz
`empowery-client` > `app-design`.

### Messen

Der Skill bringt kein Mess-Skript mit. Plugins in diesem Marktplatz enthalten
nur Text. Claude misst mit dem, was im Projekt schon da ist: Browser-Werkzeuge,
ein vorhandenes Playwright-Setup oder eine Rechnung aus den Farbwerten im Code.
Was Claude nicht messen konnte, sagt es dazu.

### Herkunft

Der Skill ist eine Neufassung. Er nutzt Inhalte aus drei Projekten unter
MIT-Lizenz. Die Liste mit festem Stand steht in
`plugins/app-design/skills/app-design/SOURCES.md`, die Lizenzhinweise in
`NOTICE.md` daneben. In `SOURCES.md` steht auch, wie wir prüfen, ob sich eine
Quelle seit unserem Stand geändert hat.

## English

A skill for the user interface of web apps in small and mid-size firms. It helps
Claude in three modes:

| Mode | When | What Claude does |
|------|------|------------------|
| Build | You want a new screen or component. | Claude sets colors and sizes as tokens first, then layout, states and copy. |
| Review | You have a screen or code and want to know what is wrong. | Claude checks in a fixed order, measures contrast and sizes, ranks by severity and proposes fixes. |
| Wording | You need German buttons, error messages or empty states. | Claude writes short, clear German UI copy: du or Sie, buttons that name the action, German number and date formats. |

Claude picks the skill on its own for web app UI work. You can also call it
directly: `/app-design:app-design`.

It targets office tools with dense tables, phone-first apps for field workers,
and white-label products where each tenant changes a few tokens. It is not meant
for native iOS or Android code or for marketing pages.

Install: `claude plugin install app-design@empowery-client --scope local`.

The skill ships no measuring script, because plugins in this marketplace hold
text only. Claude measures with what the project already has and says what it
could not measure.

Origin: a rewrite that uses material from three MIT-licensed projects. Pinned
sources and the upstream update check are in
`plugins/app-design/skills/app-design/SOURCES.md`; license notices are in
`NOTICE.md` next to it.
