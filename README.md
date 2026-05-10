# NotebookLM by Jack Vidal

Easy NotebookLM access for Jack Vidal's students. A Claude Code skill that wraps the open-source [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py) CLI with a streamlined setup, the fastest known login flow, and copy-paste workflows for the things students actually want to do.

**You get every NotebookLM feature** — sources, chat, podcasts, videos, quizzes, flashcards, mind maps, slide decks, infographics, reports, web research — **plus a few the web UI doesn't expose** (batch downloads, JSON/Markdown quiz export, mind map JSON, PPTX slides).

---

## What you need first

1. **[Claude Code](https://claude.com/claude-code)** installed (free; works in terminal, VSCode, JetBrains, or web).
2. **Python 3.10 or newer** — check with `python --version`. Get it from [python.org](https://www.python.org/downloads/).
3. **A Google account that already uses NotebookLM** at https://notebooklm.google.com.

You don't need to install anything else manually — the skill does the rest.

---

## Step 1 — Install the skill into Claude Code

```bash
npx skills add jackvidal/notebooklm-by-jack-vidal
```

That's it for setup. (Requires Node.js — install from [nodejs.org](https://nodejs.org/) if you don't have it.)

**Don't have `npx`?** Manual install: download [`SKILL.md`](SKILL.md) from this repo and save it to:
- macOS / Linux: `~/.claude/skills/notebooklm-by-jack-vidal/SKILL.md`
- Windows: `%USERPROFILE%\.claude\skills\notebooklm-by-jack-vidal\SKILL.md`

## Step 2 — Just talk to Claude Code

Open Claude Code and say:

> Connect me to my NotebookLM.

Claude does the rest:

1. **Installs the runtime** (`notebooklm-py` + Chromium for login) — ~2 minutes the first time, never again.
2. **Opens a browser window** for you to sign in to Google. Pick the account that owns your notebooks.
3. **Saves your session** so future requests don't need login.

You'll see a couple of permission prompts the first time (for `pip install` and `playwright install`) — just approve them. After this one-time setup, you can talk to Claude in plain English about your notebooks forever.

---

## Using it

Just talk to Claude Code in plain English. The skill activates automatically when you mention NotebookLM or describe a NotebookLM task. Examples:

- *"List my notebooks."*
- *"Create a new notebook called 'Bio 101' and add this PDF: ./chapter1.pdf"*
- *"In my Bio 101 notebook, generate flashcards on the hardest concepts."*
- *"Make a podcast from my Marketing notebook — 10 minutes, deep-dive style."*
- *"Run web research on 'transformer architectures' and import the sources into a new notebook."*
- *"Quiz me on the material in my Studying notebook."*
- *"Download the podcast from notebook X to my Desktop."*

Claude handles picking the right command, capturing IDs, waiting for long-running generations, and downloading results.

---

## Why this skill exists

The official `notebooklm` CLI is great, but its `notebooklm login` command **blocks the terminal forever** waiting for you to press ENTER manually. That breaks every time an AI agent tries to drive it. This skill bakes in a fast-authentication pattern (pre-piping ENTER on stdin) that lets Claude Code finish the entire setup unattended in seconds — so you can spend your time on your actual coursework, not fighting with auth flows.

Read [`SKILL.md`](SKILL.md) for the technical details.

---

## Updating

```bash
npx skills add jackvidal/notebooklm-by-jack-vidal
```

Re-running the install command pulls the latest `SKILL.md`.

---

## Credits

- Built on [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py) by Teng Lin (MIT). All the heavy lifting — every API call, every artifact format — is theirs. This skill is a thin friendly wrapper.
- Skill packaging by [Jack Vidal](https://jackvidal.com).

This project is unaffiliated with Google. NotebookLM uses undocumented Google APIs that may change without notice; rate limits apply. Best for personal learning, research, and study workflows.

## License

MIT — see [LICENSE](LICENSE).
