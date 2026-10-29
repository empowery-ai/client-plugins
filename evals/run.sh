#!/usr/bin/env bash
# Run the `claude plugin eval` suite of one plugin.
#
# Why the copy: the inventory guard allows only .claude-plugin/, output-styles/
# and skills/ in a plugin root, so eval cases live in evals/<plugin>/. But
# `claude plugin eval --eval-dir` must stay inside the plugin root. This script
# copies the plugin and its cases into a temp dir and runs the suite there.
#
# Usage: evals/run.sh <plugin> [extra claude plugin eval flags]
# Example: evals/run.sh klartext --case repitch-order --runs 1
set -euo pipefail

name="${1:?usage: evals/run.sh <plugin> [extra claude plugin eval flags]}"
shift
repo="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
  echo "invalid plugin name: $name" >&2
  exit 1
fi
for d in "$repo/plugins/$name" "$repo/evals/$name"; do
  if [ ! -d "$d" ]; then
    echo "missing directory: $d" >&2
    exit 1
  fi
done
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cp -R "$repo/plugins/$name" "$tmp/$name"
cp -R "$repo/evals/$name" "$tmp/$name/evals"
rm -rf "$tmp/$name/evals/results"

out="$repo/evals/$name/results/$(date -u +%Y-%m-%dT%H-%M-%SZ)"
mkdir -p "$out"

# --ablation none: without the plugin the slash command does not exist, so a
# no-plugin arm measures nothing. --no-publish: the report stays local.
# --allow-tools Bash: only cases that list Bash in allowed_tools get it. The
# klartext no-tool-calls case offers Bash so that a grader can prove it is
# never used.
# --judge-model sonnet: the default haiku judge failed good German re-pitches
# in about half the runs; sonnet judged the same answers stably.
claude plugin eval "$tmp/$name" \
  --ablation none \
  --no-publish \
  --trust-plugin \
  --allow-tools Bash \
  --judge-model sonnet \
  --output-dir "$out" \
  "$@"
