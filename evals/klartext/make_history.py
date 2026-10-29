"""Build history.jsonl for one eval case from its prior-question.md and prior-answer.md.

The history file seeds one finished turn (user question, assistant answer) so the
case prompt (/klartext:wait-what) has a "last answer" to act on. It uses the
Claude Code session transcript shape that `context.history_file` loads.

`{EMDASH}` in a source file becomes a real em dash in the seeded turn, so the
no-em-dash graders have something to resist. The repo files never hold the
character itself: history.jsonl stores it as a JSON escape.

Usage: python3 evals/klartext/make_history.py evals/klartext/<case>
"""
import json
import pathlib
import sys
import uuid

EM_DASH = chr(0x2014)
EM_DASH_ESCAPED = "\\u%04x" % 0x2014

case = pathlib.Path(sys.argv[1])
question = (case / "prior-question.md").read_text(encoding="utf-8").strip()
answer = (case / "prior-answer.md").read_text(encoding="utf-8").strip()
question = question.replace("{EMDASH}", EM_DASH)
answer = answer.replace("{EMDASH}", EM_DASH)

session = str(uuid.uuid5(uuid.NAMESPACE_URL, "session:" + case.name))
u_id = str(uuid.uuid5(uuid.NAMESPACE_URL, "user:" + question))
a_id = str(uuid.uuid5(uuid.NAMESPACE_URL, "assistant:" + answer))
common = {
    "isSidechain": False,
    "userType": "external",
    "cwd": "/workspace",
    "sessionId": session,
    "version": "2.1.312",
}
lines = [
    {
        **common,
        "type": "user",
        "parentUuid": None,
        "uuid": u_id,
        "timestamp": "2026-10-29T09:00:00.000Z",
        "message": {"role": "user", "content": question},
    },
    {
        **common,
        "type": "assistant",
        "parentUuid": u_id,
        "uuid": a_id,
        "timestamp": "2026-10-29T09:00:05.000Z",
        "message": {
            "id": "msg_" + a_id.replace("-", "")[:24],
            "type": "message",
            "role": "assistant",
            "model": "claude-sonnet-5-5",
            "content": [{"type": "text", "text": answer}],
            "stop_reason": "end_turn",
            "stop_sequence": None,
            "usage": {"input_tokens": 0, "output_tokens": 0},
        },
    },
]
with open(case / "history.jsonl", "w", encoding="utf-8") as f:
    for line in lines:
        f.write(json.dumps(line, ensure_ascii=False).replace(EM_DASH, EM_DASH_ESCAPED) + "\n")
