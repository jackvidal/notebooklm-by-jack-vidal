---
name: notebooklm-by-jack-vidal
description: Easy NotebookLM access for Jack Vidal's students. One-skill setup that handles install, fast authentication (instant-ENTER trick that avoids the usual blocking prompt), and common workflows for chatting with sources and generating podcasts, videos, quizzes, mind maps, and more. Activates on /notebooklm, "use notebooklm", or intent like "create a podcast about X", "summarize these sources", "make a quiz from notebook Y", "add this PDF to NotebookLM".
---
<!-- notebooklm-by-jack-vidal — wraps notebooklm-py CLI v0.4.0+ -->
# NotebookLM by Jack Vidal

A friendly entry point to Google NotebookLM for Jack Vidal's students. Wraps the open-source `notebooklm-py` CLI (https://github.com/teng-lin/notebooklm-py) with a streamlined setup, the fastest known login flow, and copy-paste workflows for the things students actually want to do.

**What you get:** every NotebookLM feature (sources, chat, podcasts, videos, quizzes, flashcards, mind maps, slide decks, infographics, reports, web research) plus a few things the web UI doesn't expose (batch downloads, JSON/Markdown quiz export, mind map JSON, PPTX slides).

## 1. One-time install

```bash
pip install "notebooklm-py[browser]"
playwright install chromium
```

If you already have Python 3.10+ and pip, that's the whole install. (On Windows, run in PowerShell. On macOS/Linux, any terminal.)

## 2. Fast authentication

The standard `notebooklm login` opens a browser, waits for you to sign in, then **blocks forever waiting for you to press ENTER in the terminal**. That works fine when you're typing manually, but it breaks every time an AI agent tries to drive it. Use this pattern instead — it pre-queues the ENTER so authentication finishes the moment your Google session is in the browser profile.

### The decision tree

Always start with this:

```bash
notebooklm auth check --test
```

Then branch on the result:

| Result | Run this |
|---|---|
| **`Authentication is valid`** | Done — skip to step 3. |
| **`Storage file not found`** but you've signed in before | **Path A** below (instant, ~2 seconds) |
| **First time ever**, or **`Token fetch ✗ fail`** (cookies expired) | **Path B** below (one-time interactive, ~30–90s) |

### Path A — Instant re-extract

The Chromium profile on disk still has your Google session. Just dump it to `storage_state.json`:

```bash
echo "" | notebooklm login
```

That's it. The pipe sends ENTER immediately, the script writes the cookie file, done.

### Path B — Interactive sign-in (first time)

You'll sign into Google in a Chromium window. The trick is to launch it with a stdin pipe that auto-presses ENTER on a timer, so the script can finish even if no human is at the keyboard.

**If a human is at the keyboard** (the simple case):

```bash
notebooklm login --fresh
# 1. Sign in to Google in the Chromium window
# 2. Wait until you see your NotebookLM home page
# 3. Switch back to the terminal and press ENTER
```

**If an AI agent is driving the install** (the magic case):

Run this in the agent's background-task mode so the agent doesn't block:

```bash
( sleep 240; echo "" ) | notebooklm login --fresh
```

The agent tells the student "sign in within 4 minutes." When the timer fires, ENTER is sent automatically and the cookie file is written. **Even faster:** as soon as the student says "I'm signed in," the agent kills the background task and runs Path A — that captures the live session in ~2 seconds instead of waiting out the timer.

### Verify

```bash
notebooklm auth check --test    # all five rows should be ✓ pass
notebooklm list                 # should show your notebooks
```

## 3. Everyday commands

| Want to... | Command |
|---|---|
| See your notebooks | `notebooklm list` |
| Pick a notebook to work in | `notebooklm use <notebook_id>` |
| Create a new notebook | `notebooklm create "Title"` |
| Add a web page | `notebooklm source add "https://..."` |
| Add a PDF / Word / Markdown / EPUB / audio / video / image | `notebooklm source add ./file.pdf` |
| Add a YouTube video | `notebooklm source add "https://youtube.com/watch?v=..."` |
| Have AI do web research and import sources | `notebooklm source add-research "your topic"` |
| List sources in current notebook | `notebooklm source list` |
| Ask a question about your sources | `notebooklm ask "your question"` |
| Get an answer with citations | `notebooklm ask "your question" --json` |
| Save the answer as a notebook note | `notebooklm ask "..." --save-as-note` |
| Show conversation history | `notebooklm history` |

## 4. Generating things

All of these run for several minutes. Start them, capture the artifact ID, and check back later — don't sit and wait.

| Want to make a... | Command | Then download with |
|---|---|---|
| Podcast (audio overview) | `notebooklm generate audio "make it engaging"` | `notebooklm download audio ./podcast.mp3` |
| Video overview | `notebooklm generate video --style whiteboard` | `notebooklm download video ./video.mp4` |
| Slide deck | `notebooklm generate slide-deck` | `notebooklm download slide-deck ./slides.pdf` (or `.pptx --format pptx`) |
| Quiz | `notebooklm generate quiz --difficulty medium` | `notebooklm download quiz ./quiz.json` (or `.md --format markdown`) |
| Flashcards | `notebooklm generate flashcards` | `notebooklm download flashcards ./cards.json` |
| Mind map | `notebooklm generate mind-map` | `notebooklm download mind-map ./map.json` |
| Briefing doc / study guide / blog post | `notebooklm generate report --format study-guide` | `notebooklm download report ./report.md` |
| Data table from sources | `notebooklm generate data-table "compare key concepts"` | `notebooklm download data-table ./data.csv` |
| Infographic | `notebooklm generate infographic --orientation portrait` | `notebooklm download infographic ./image.png` |

To check progress: `notebooklm artifact list`. To wait for one in a script: `notebooklm artifact wait <artifact_id>`.

## 5. Activation triggers

Invoke this skill when the student says any of:

- `/notebooklm`, "use notebooklm", any direct mention of NotebookLM
- "Create a podcast / audio overview about [topic]"
- "Summarize these URLs / PDFs / sources"
- "Make a quiz / flashcards / mind map / video / slide deck / infographic from notebook X"
- "Add this PDF / link / YouTube video to NotebookLM"
- "Run web research on [topic] and import the sources"
- "Download the podcast / quiz / report from notebook X"
- "What does my notebook say about [topic]?"

## 6. Autonomy rules (for the AI agent using this skill)

**Run automatically — no need to ask:**
- `auth check`, `auth check --test`, `status`, `list`, `source list`, `artifact list`, `language list`, `language get`, `history`
- `notebooklm use <id>`, `create`, `source add`, `source add-research` (fast mode)
- `ask "..."` without `--save-as-note`
- The Path A/B login flow above when `auth check --test` fails

**Confirm with the student first:**
- `notebooklm delete` / `notebook delete` — destructive
- `notebooklm generate *` — runs for many minutes, can fail with rate limits
- `notebooklm download *` — writes to filesystem
- `artifact wait` / `source wait` / `research wait` in the **main** conversation — blocks for minutes
- `ask "..." --save-as-note`, `history --save` — writes notes into the notebook
- `language set` — changes a global account-wide setting

## 7. Workflows worth memorizing

### "Turn this article into a podcast" (5–10 min)

1. `notebooklm create "Podcast: <topic>"` (or `use` an existing notebook)
2. `notebooklm source add "<url-or-path>"`
3. Wait ~30–60s for processing: `notebooklm source list` until status is `ready`
4. `notebooklm generate audio "Focus on the most surprising insight" --json` → note the `task_id`
5. Come back in 10–20 min, `notebooklm artifact list`
6. `notebooklm download audio ./podcast.mp3`

### "Study these PDFs" (1–2 min)

1. `notebooklm create "Studying: <subject>"`
2. `notebooklm source add ./chapter1.pdf` (repeat for each file)
3. `notebooklm generate flashcards --difficulty medium`
4. `notebooklm generate quiz`
5. `notebooklm ask "Quiz me on the hardest concepts"`

### "Research a topic from scratch" (2–5 min for fast, 15–30 min for deep)

1. `notebooklm create "Research: <topic>"`
2. `notebooklm source add-research "<topic query>" --mode fast` (or `--mode deep --no-wait`)
3. Once sources are imported, `notebooklm generate report --format briefing-doc`
4. `notebooklm download report ./briefing.md`

## 8. Useful flags

- `--json` — machine-readable output for any command. Pipe to `jq`.
- `-n <notebook_id>` / `--notebook <notebook_id>` — target a specific notebook without `use`. **Required when running multiple agents in parallel.**
- `-s <source_id>` — limit a question or generation to specific sources.
- `--language <code>` — output language for generated content (`en`, `es`, `fr`, `ja`, `zh_Hans`, `he`, etc. — `notebooklm language list` for all).
- `--retry N` — auto-retry on rate limits with exponential backoff.

## 9. Troubleshooting

| Symptom | Try this |
|---|---|
| Login hangs forever | You forgot the `echo "" \|` prefix. Cancel and re-run with the pipe. |
| Chromium opens then immediately closes | Stale browser profile. Run `notebooklm login --fresh` (Path B). |
| `auth check` says cookies expired | Try Path A first. If still failing, run Path B with `--fresh`. |
| Generation fails with rate-limit error | Wait 5–10 minutes and retry, or use the NotebookLM web UI as a fallback. |
| "No notebook context" error | You forgot to set context. Pass `-n <notebook_id>` or run `notebooklm use <id>`. |
| Anything else weird | `notebooklm doctor` — runs full environment health check. |

## 10. Where things live

- Auth cookies: `~/.notebooklm/profiles/default/storage_state.json`
- Browser profile: `~/.notebooklm/profiles/default/browser_profile/`
- Notebook context: `~/.notebooklm/profiles/default/context.json`
- Multiple Google accounts: `notebooklm profile create work` then `notebooklm -p work login`

## 11. Credits and the deeper reference

This skill is built on `notebooklm-py` by Teng Lin (https://github.com/teng-lin/notebooklm-py, MIT). It is an unofficial library that uses undocumented Google APIs — APIs may change without notice, rate limits apply, and Google can throttle heavy use. Best for personal learning, research, and study workflows.

For every command, every flag, every artifact format, JSON schemas, and the full troubleshooting table, see the upstream skill at `~/.claude/skills/notebooklm/SKILL.md` (installed by `notebooklm skill install`). This skill is the friendly front door; that one is the encyclopedia.
