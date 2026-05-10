# NotebookLM by Jack Vidal

Easy NotebookLM access for Jack Vidal's students. A Claude Code skill that wraps the open-source [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py) CLI with a streamlined setup, the fastest known login flow, and copy-paste workflows for the things students actually want to do.

**You get every NotebookLM feature** — sources, chat, podcasts, videos, quizzes, flashcards, mind maps, slide decks, infographics, reports, web research — **plus a few the web UI doesn't expose** (batch downloads, JSON/Markdown quiz export, mind map JSON, PPTX slides).

---

## What you need first

1. **[Claude Code](https://claude.com/claude-code)** installed (free; works in terminal, VSCode, JetBrains, or web).
2. **Python 3.10 or newer** — check with `python --version`. Get it from [python.org](https://www.python.org/downloads/).
3. **A Google account that already uses NotebookLM** at https://notebooklm.google.com.

That's it. Total install time: ~3 minutes.

---

## Step 1 — Install the skill into Claude Code

```bash
npx skills add jackvidal/notebooklm-by-jack-vidal
```

That single command downloads this skill and registers it with Claude Code. (Requires Node.js — install from [nodejs.org](https://nodejs.org/) if you don't have it.)

**Don't have `npx`?** Manual install: download [`SKILL.md`](SKILL.md) from this repo and save it to:
- macOS / Linux: `~/.claude/skills/notebooklm-by-jack-vidal/SKILL.md`
- Windows: `%USERPROFILE%\.claude\skills\notebooklm-by-jack-vidal\SKILL.md`

## Step 2 — Install the underlying CLI

```bash
pip install "notebooklm-py[browser]"
playwright install chromium
```

## Step 3 — Sign into your Google account

Open Claude Code and just say:

> Connect me to my NotebookLM.

Claude will run the right login flow for you. A Chromium window will pop up — sign in with the Google account that owns your notebooks, and you're done. Subsequent sessions don't need this step.

If you'd rather do it manually:

```bash
notebooklm login --fresh
# Sign into Google in the Chromium window
# Wait until you see your NotebookLM home page
# Switch back to the terminal and press ENTER
```

Verify with `notebooklm auth check --test` — all five rows should be ✓ pass.

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
