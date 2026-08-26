---
name: session-context
description: Hilft beim Gedächtnis über Sessions hinweg. Nutze diesen Skill, wenn der Nutzer fragt "was wussten wir letzte Woche", "hast du das noch", "Kontext über Sessions", "session fortsetzen", "wie mache ich weiter wo ich aufgehört habe", "memory", "wo speichert Claude das", "CLAUDE.md pflegen", "warum vergisst du das", oder wenn er sich über verlorenen Kontext beschwert.
---

# Kontext über Sessions hinweg

Claude Code vergisst am Ende einer Session nicht alles. Es gibt drei getrennte Dinge. Halte sie auseinander.

## 1. Auto-Memory

Claude kann sich selbst Notizen schreiben. Diese Notizen kommen in der nächsten Session zurück.
Diese Funktion ist ab Werk eingeschaltet.

**Rechne den Zustand nicht selbst aus.** Es gibt mehrere Orte, an denen die Einstellung stehen kann.
Es gibt eine Rangfolge zwischen ihnen. Diese Rangfolge zu raten geht zu leicht schief.

Mach es stattdessen so:

1. Sag dem Nutzer: "Tippe `/memory` und drücke Enter."
2. Sag: "Lies mir vor, was da steht."
3. Arbeite mit dem, was der Nutzer vorliest. Nicht mit einer Vermutung.

Wenn der Nutzer sagt, Auto-Memory ist aus, und er will es an: die Umschaltung passiert im `/memory`-Fenster.

## 2. CLAUDE.md

`CLAUDE.md` ist eine normale Textdatei im Projekt. Claude liest sie bei jedem Start.
Da gehört hinein, was immer gilt. Zum Beispiel: wie das Projekt aufgebaut ist, welche Sprache gilt, welche Regeln fest sind.

Regel für dich: Schreibe kurze Sätze in `CLAUDE.md`. Eine Regel pro Zeile.
Schreibe nichts hinein, was nur heute gilt. Dafür ist Auto-Memory da.

## 3. Alte Sessions wieder öffnen

Der Weg heute ist `/resume`. Tippe `/resume` und wähle die Session aus der Liste.
Benutze nicht `--continue`. Der Weg über `/resume` zeigt die Liste und ist der verlässliche.

Es gibt eine Einstellung namens `cleanupPeriodDays`. Sie räumt nur die alten Gesprächsprotokolle auf.
Sie löscht kein Auto-Memory und keine `CLAUDE.md`. Verwechsle die beiden nicht.

## So antwortest du

Sag dem Nutzer immer genau **einen** nächsten Schritt. Nie eine Liste von fünf.

Beispiel:

> Deine Notizen von letzter Woche liegen in zwei Töpfen.
> Tippe jetzt `/memory` und lies mir vor, was oben steht.

Wenn du nicht weißt, ob Auto-Memory an ist: sag das offen. Rate nicht.
