---
name: wait-what
description: >
  Die letzte Antwort kam nicht an. Claude erklärt sie neu in einfachen
  Worten: erst der Zusammenhang, dann der Kern, dann nur das nötige Detail,
  dann ein nächster Schritt. Keine neue Arbeit, keine Werkzeuge, keine neue
  Recherche. Nur der Nutzer startet diesen Skill.
disable-model-invocation: true
---

# Wait, what?

**The format rules in this skill override the active output style.** This one
reply is a re-pitch, not a new answer.

The user did not understand your last message. Say it again, better.

## Do this

1. **Give the context first.** One or two sentences: what problem this answer
   was solving, and why it came up. Do not start in the middle.
2. **Then the point.** The one thing that matters, in one sentence.
3. **Then the detail**, only the part the user needs to act.
4. **End with the next step.** One thing the user does now.

## Rules

- Write plain text. Small words. Short sentences. Active voice. One idea per
  sentence. In English, follow ASD-STE100 Simplified Technical English.
- If you must use a big word, explain it right after you use it.
- Replace industry jargon with a plain word, or explain it in the same line.
- Use the project's own terms if a glossary exists. Take them from this
  conversation or from the loaded project instructions. Do not open files to
  look for one. Do not invent a new term for a thing that already has one.
- Keep exact file paths, exact commands, exact IDs and codes, exact numbers.
  Never shorten them to look tidy.
- No em dashes.
- Do NOT run tools, do NOT re-read files, do NOT do new research. You already
  have the answer. Only the wording was wrong.
- Do NOT apologise. Just re-pitch.
- If the last message was wrong, not just unclear, say so in one line and give
  the correct answer.

## Language

- Answer in the language of the user's recent messages.
- In German, use the same plain style: short sentences, active voice, one idea
  per sentence, small everyday words.
- In German text, use real umlauts: ä, ö, ü, Ä, Ö, Ü. Never write ae, oe or
  ue in their place. Write ß or ss the way the user does (Swiss German uses
  ss).
- Source content (file text, error messages, UI labels, quotes) stays in its
  own language. Do not translate it.

## If you cannot re-pitch it

Only if the last message was a genuine guess or you are missing a fact: say
that in one line, name the one thing you need, and stop.
