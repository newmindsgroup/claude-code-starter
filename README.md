# claude-code-starter

A person-agnostic starter for [Claude Code](https://claude.com/claude-code). Clone it as your `~/.claude` and every session — on every project, including subagents — starts with a strong, opinionated baseline: a working-style instruction spine, safety hooks, a portable setup script, and an optional four-pillar PR-review workflow.

Built from a real production setup, stripped of all personal and company specifics. Fill in the placeholders and it's yours.

## Quick start

1. Click **“Use this template” → Create a new repository** (keep it private if it'll hold anything sensitive).
2. Install prerequisites: [Claude Code](https://claude.com/claude-code), plus `git`, `jq`, and `node` (macOS: `brew install git jq node`).
3. Install it as your `~/.claude`:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/YOU/YOUR-REPO/main/bootstrap.sh | bash -s -- https://github.com/YOU/YOUR-REPO.git
   ```
   The script is idempotent and non-destructive — it backs up anything it would touch and adopts an existing `~/.claude` if Claude Code already created one.
4. Open `~/.claude/CLAUDE.md`, search for `{{`, and replace every placeholder with your details. Delete sections you don't need.
5. Start a new Claude Code session.

## What's inside

| File | What it does |
|---|---|
| `CLAUDE.md` | Your instruction spine: skill-leverage habit, qualifying-questions protocol, the four-pillar engineering mantra, look-around-the-corner, skill-worthiness radar, sequenced next steps. Edit freely. |
| `settings.json` | Two safety **hooks** — a guard that blocks Claude from reading `.env`/key/credential files, and an auto-formatter that runs Prettier on edited files when available. Plus an empty permission allowlist to grow. |
| `.gitignore` | Keeps runtime data (transcripts, sessions, caches, plugin installs) out of git — only your config and memories are tracked. |
| `bootstrap.sh` | New-machine setup: clone/adopt `~/.claude`, link skills, print next steps. |
| `.github/workflows/claude-code-review.yml` | Optional CI: reviews every PR against the four pillars. **No-ops safely** until a credential secret exists, so it never blocks merges. |
| `memory/` | Scaffold for persistent, cross-session memories (with the format documented and an example). |
| `skills/` | Drop user-level skills here; `bootstrap.sh` links them into `~/.agents/skills` for cross-tool use. |

## The four pillars

Every piece of code, app, or infrastructure is held to **Security · Stability · Reliability · Compliance**. These are industry best practice, not personal taste — they're the default in `CLAUDE.md` and the rubric the CI review uses. Edit them if your team's standard differs.

## Enabling the CI review (optional)

The workflow stays dormant (green no-op with a notice) until you add a credential secret to each repo:

- **Claude Pro/Max subscription** (no per-token billing): run `claude setup-token`, then
  ```bash
  gh secret set CLAUDE_CODE_OAUTH_TOKEN -R YOU/REPO
  ```
- **Or an API key:** `gh secret set ANTHROPIC_API_KEY -R YOU/REPO`

Also install the [Claude GitHub App](https://github.com/apps/claude) so it can post review comments. The workflow only runs on non-draft, same-repo PRs and uses comment-only tools.

## Customizing

- **`CLAUDE.md`** — the placeholders are the minimum; add your stack conventions, repo patterns, and an optional brand/voice SSOT pointer (a commented template is included).
- **`settings.json`** — grow `permissions.allow` to stop repeat prompts for tools you trust; tweak or remove either hook. The auto-format hook assumes Prettier — swap in your formatter.
- **Machine-local overrides** go in `settings.local.json` (gitignored), not the tracked `settings.json`.
- **Scheduled routines, MCP servers, plugins** are personal — add them on your machine; they aren't part of this shared template.

## Multi-machine

Re-run `bootstrap.sh` (or `git -C ~/.claude pull`) on any machine to sync. Most tracked files are append-only, so conflicts are rare.

## License

MIT — see [LICENSE](LICENSE). Use it, fork it, make it your team's standard.
