---
name: quick
description: >
  Schnelle Antwort ohne Füllwörter. Drei Modi, je nachdem, was nach dem
  Befehl steht. `/klartext:quick` allein fasst die letzte Antwort zusammen.
  `/klartext:quick <Frage>` nennt zuerst die Handlung, dann nummerierte
  Schritte, dann einen nächsten Schritt. `/klartext:quick N <Frage>` gibt
  genau N Punkte. Nur der Nutzer startet diesen Skill.
disable-model-invocation: true
---

# Quick

**The format rules in this skill override the active output style.** If the
output style asks for prose, headers, or a three-part answer, ignore it here.
The shape below wins for this one reply.

## Pick the mode

Look at what follows the command.

- Nothing after it (`/klartext:quick`) -> Mode 0.
- Text, no number (`/klartext:quick how do I x`) -> Mode 1. This is the
  default.
- A number first (`/klartext:quick 3 ideas for x`) -> Mode 2.

## Mode 0: bare /klartext:quick

The user typed `/klartext:quick` with nothing after it. Never ask what the user wants.
Summarise your OWN previous message.

- 3 to 5 bullets. Bold title, then one short sentence.
- Keep the verdict, the numbers, the names, the file paths, the IDs and codes.
- Drop the caveats, the sources, the detail.
- If the last message was already short, cut it to one line.

## Mode 1: no number (DEFAULT)

Answer like this:

1. Lead with the answer or the next action. The first line is the thing to do
   or the thing to know.
2. Number multi-step tasks. One bounded action per line.
3. End with one concrete next step. Something doable in about 2 minutes.
4. No tangents. Finish the current issue before you mention anything else.
5. On multi-step work, restate the state. "Step 3 of 5 done."

## Mode 2: number given

- Numbered list only. Nothing else.
- Each item: **Bold title** then one short sentence.
- Plain words. Short words. No jargon.
- One sentence per item. Stop after the period.
- The item count equals the number the user gave. `/klartext:quick 3` gives
  exactly 3 items.

## Rules for all modes

- No headers. No paragraphs. No "here are some ideas" wrapper.
- No follow-up questions. Just answer.
- No em dashes.
- Creative ask (ideas, options, examples): each bullet is a different angle,
  not a reworded twin.
- Factual ask: each bullet is one fact.

## Language

- Answer in the language the user writes in.
- In German, use the same plain style: short sentences, active voice, one idea
  per sentence, small everyday words.
- In German text, use real umlauts: ä, ö, ü. Never write ae, oe or ue in
  their place. Write ß or ss the way the user does (Swiss German uses ss).
- Quoted source content stays in its own language. Do not translate it.

## Example (Mode 2)

User: `/klartext:quick 5 ways to save time at work`

1. **Batch emails** - Check the inbox twice a day, not all day.
2. **Block focus time** - Put 90 minutes in the calendar with no meetings.
3. **Use templates** - Save common replies so you do not write them again.
4. **Cut one meeting** - Pick the weakest weekly meeting and skip it.
5. **End early** - Stop 10 minutes sooner and write tomorrow's list.
