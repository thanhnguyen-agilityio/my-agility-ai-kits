---
name: unslop
description: Clean AI-sounding writing (notes, questions, issue comments, docs) so it reads plain and human while keeping meaning, facts, and voice. Use when the user says "unslop", "de-AI this", "make it sound natural", or asks to polish text before sending it.
---

# Unslop

Rewrite text so it reads like a busy senior engineer wrote it. Meaning, facts, and intent stay; filler and AI tells go.

Inspired by https://github.com/theclaymethod/unslop (simple version: no scanners, no voice profile).

## Input

- A file path, a selection, or pasted text. If none given, ask which text.
- Default: edit the file in place. For pasted text, reply with the cleaned text only.

## Pass 1: phrases (delete or replace)

- Throat-clearing openers: "Let's dive in", "It's worth noting that", "In today's world", "Great question".
- Emphasis crutches: "Full stop.", "Let that sink in", "The truth is", "Make no mistake".
- Vague attribution: "Experts say", "Studies show" (name the source or drop it).
- Jargon: "leverage", "navigate challenges", "move the needle", "circle back", "robust", "seamless", "delve".
- Chatbot residue: "I hope this helps", "Feel free to reach out", "As an AI", "Certainly!".
- Filler words: "just", "really", "basically", "actually", "simply", "very".

## Pass 2: structure

- "It's not X, it's Y" contrasts and self-answered questions ("The result? ..."): state the point directly.
- Em dashes: replace with a period, comma, colon, or parentheses. None in the output.
- Staccato runs of one-line punchy sentences: merge into normal sentences.
- Uniform sentence length and rhythm: vary it.
- Rule-of-three lists that exist for rhythm, not content: keep only the real items.
- Recap endings and moral codas ("In short, ...", "Ultimately, ..."): delete unless they add something.
- Bullets that are really one sentence: turn back into prose.

## Pass 3: substance

- One idea per sentence. Lead with the point.
- Concrete over abstract: names, numbers, file names, routes.
- Cut hedges that add nothing ("might possibly", "it seems that").

## Do no harm

Never change:

- Code, identifiers, routes, config keys, quoted text, links.
- Numbers, dates, scopes, limits, or any factual claim.
- Deliberate hedges that carry meaning (e.g. "to be verified in the sandbox", legal or security caveats).
- Questions addressed to someone: keep them as questions, same ask.
- Verbatim transcriptions (files marked "Transcribed from ..."): do not touch.

## Output

1. The cleaned text (or the edited file).
2. At most three lines: what kinds of changes were made. No per-change essay.
