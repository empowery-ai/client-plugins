# klartext

[Deutsch](#deutsch) · [English](#english)

## Deutsch

Zwei Reparatur-Befehle für Claude Code. Sie helfen, wenn eine Antwort nicht
ankommt. Claude startet sie nie von selbst. Nur du tippst sie.

### Was die Befehle tun

| Befehl | Wann tippen | Was passiert |
|--------|-------------|--------------|
| `/klartext:wait-what` | Du verstehst die letzte Antwort nicht. | Claude erklärt die letzte Antwort neu. Erst der Zusammenhang, dann der Kern, dann nur das nötige Detail, dann ein nächster Schritt. Claude nutzt dabei keine Werkzeuge und recherchiert nicht neu. War die letzte Antwort falsch, sagt Claude das in einer Zeile. |
| `/klartext:quick` | Die letzte Antwort ist zu lang. | Claude fasst die letzte Antwort in 3 bis 5 Punkten zusammen. |
| `/klartext:quick <Frage>` | Du willst eine kurze Antwort. | Claude nennt zuerst die Handlung, dann nummerierte Schritte, dann einen nächsten Schritt. |
| `/klartext:quick N <Frage>` | Du willst genau N Punkte. | Claude gibt genau N Punkte. Jeder Punkt hat einen fetten Titel und einen Satz. |

Beide Befehle antworten in deiner Sprache. Auf Deutsch schreiben sie kurze
Sätze im Aktiv, mit einem Gedanken pro Satz. Dateipfade, Befehle und Zahlen
bleiben exakt. Beide Befehle gelten nur für die eine Antwort. Danach gilt
wieder dein normaler Antwortstil.

### Beispiel: `/klartext:wait-what`

Vorher (Claude):

> Der 502 ist ein Upstream-Timeout im Reverse Proxy. nginx hat per Default
> `proxy_read_timeout` 60s. Setz `proxy_read_timeout 300s;` in
> `/etc/nginx/conf.d/app.conf` oder entkopple den Export in einen Async-Job
> mit Polling-Endpoint.

Du tippst: `/klartext:wait-what`

Nachher (Claude):

> Dein CSV-Export bricht nach etwa einer Minute mit Fehler 502 ab.
>
> Der Export dauert länger, als nginx wartet. nginx wartet von sich aus
> nur 60 Sekunden.
>
> Du hast zwei Wege. Erhöhe die Wartezeit. Oder lass den Export im
> Hintergrund laufen. Dann wartet keine Anfrage lange.
>
> Nächster Schritt: Öffne `/etc/nginx/conf.d/app.conf` und setze
> `proxy_read_timeout 300s;`. Lade danach nginx neu.

### Beispiel: `/klartext:quick`

Vorher: Claude schreibt sechs Absätze über drei Wege, eine Datenbank zu
sichern.

Du tippst: `/klartext:quick`

Nachher:

> - **Empfehlung** - Sichere die Datenbank jede Nacht um 02:00 mit `pg_dump`.
> - **Ablage** - Lege die Datei in `s3://backup/db/` ab.
> - **Test** - Spiele einmal im Monat ein Backup zurück.

### Einbau

```bash
claude plugin install klartext@empowery-client --scope local
```

Danach Claude Code komplett neu starten.

### Abschalten

```bash
claude plugin disable klartext@empowery-client --scope local
```

Danach Claude Code neu starten. Mehr zu Scopes und zum Notfall steht in der
[README des Marktplatzes](../../README.md#abschalten-kill-switch).

## English

Two repair commands for Claude Code. They help when an answer does not land.
Claude never starts them on its own. Only you type them.

### What the commands do

| Command | When to type it | What happens |
|---------|-----------------|--------------|
| `/klartext:wait-what` | You do not understand the last answer. | Claude says the last answer again in plain words. Context first, then the point, then only the detail you need, then one next step. It uses no tools and does no new research. If the last answer was wrong, Claude says so in one line. |
| `/klartext:quick` | The last answer is too long. | Claude cuts the last answer to 3 to 5 bullets. |
| `/klartext:quick <question>` | You want a short answer. | Claude gives the action first, then numbered steps, then one next step. |
| `/klartext:quick N <question>` | You want exactly N points. | Claude gives exactly N points. Each point has a bold title and one sentence. |

Both commands answer in your language. File paths, commands and numbers stay
exact. Both commands apply to one answer only. After that, your normal
output style applies again.

### Example: `/klartext:wait-what`

Before (Claude):

> The 502 is an upstream timeout at the reverse proxy layer. nginx defaults
> `proxy_read_timeout` to 60s. Set `proxy_read_timeout 300s;` in
> `/etc/nginx/conf.d/app.conf`, or decouple the export into an async job
> with a polling endpoint.

You type: `/klartext:wait-what`

After (Claude):

> Your CSV export stops with error 502 after about one minute.
>
> The export takes longer than nginx waits. By default, nginx waits only
> 60 seconds.
>
> You have two ways. Raise the wait time. Or run the export in the
> background. Then no request waits long.
>
> Next step: Open `/etc/nginx/conf.d/app.conf` and set
> `proxy_read_timeout 300s;`. Then reload nginx.

### Example: `/klartext:quick`

Before: Claude writes six paragraphs about three ways to back up a database.

You type: `/klartext:quick`

After:

> - **Pick this** - Back up the database every night at 02:00 with `pg_dump`.
> - **Store it** - Put the file in `s3://backup/db/`.
> - **Test it** - Restore one backup each month.

### Install

```bash
claude plugin install klartext@empowery-client --scope local
```

Then restart Claude Code fully.

### Turn it off

```bash
claude plugin disable klartext@empowery-client --scope local
```

Then restart Claude Code.

## Tests

The eval suite is in [`evals/klartext/`](../../evals/klartext/). Run it with:

```bash
evals/run.sh klartext
```
