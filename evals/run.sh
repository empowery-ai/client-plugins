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
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cp -R "$repo/plugins/$name" "$tmp/$name"
cp -R "$repo/evals/$name" "$tmp/$name/evals"
rm -rf "$tmp/$name/evals/results"

out="$repo/evals/$name/results/$(date -u +%Y-%m-%dT%H-%M-%SZ)"
mkdir -p "$out"

# --ablation none: without the plugin the slash command does not exist, so a
# no-plugin arm measures nothing. --no-publish: the report stays local.
claude plugin eval "$tmp/$name" \
  --ablation none \
  --no-publish \
  --trust-plugin \
  --output-dir "$out" \
  "$@"
