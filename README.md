# ai-agent-config-template

A person-agnostic, **IDE-agnostic** starting config for AI coding agents. The core is a single `AGENTS.md` — the open [AGENTS.md](https://agents.md/) standard read natively by **Claude Code, Codex, Cursor, and Antigravity** — carrying a strong, opinionated baseline: a working-style spine, a four-pillar engineering mantra (Security · Stability · Reliability · Compliance), proportional rigor, attribution, third-party-trust, data-handling, and truthfulness/escalation rules.

Built from a real production setup, stripped of all personal and company specifics. Fill in the placeholders and it's yours.

## Use it in any IDE

The one file you need everywhere is **`AGENTS.md`**. Replace the `{{PLACEHOLDERS}}`, then:

| Tool | How to use it |
|---|---|
| **Any project, any tool** | Drop `AGENTS.md` in your repo root. Claude Code, Codex, Cursor, and Antigravity all read it automatically. |
| **Codex (global)** | Copy `AGENTS.md` to `~/.codex/AGENTS.md` for defaults across every project. |
| **Cursor** | `AGENTS.md` in the repo root works as-is; or paste it into Settings → Rules → User Rules for a global rule. |
| **Antigravity** | Copy into `~/.gemini/GEMINI.md` (global) or `.agents/rules/` (workspace). Mind the 12,000-char/-file limit. |
| **Claude Code** | `AGENTS.md` in a repo, or clone this whole template as your `~/.claude` for the full setup (hooks, skills, CI) — see below. |

## Quick start

1. Click **"Use this template" → Create a new repository** (keep it private if it'll hold anything sensitive).
2. Open `AGENTS.md`, search for `{{`, and replace every placeholder with your details. Delete sections you don't need.
3. Use it however fits your tool (table above). That's it for the IDE-agnostic core.

## What's inside

| File | What it is | Scope |
|---|---|---|
| `AGENTS.md` | The instruction spine: skill-leverage habit, qualifying-questions protocol, four-pillar engineering mantra, proportional rigor, attribution, third-party-trust, data-handling, truthfulness/escalation, look-around-the-corner, skill-worthiness radar, sequenced next steps. | **Every IDE** |
| `CLAUDE.md` | Symlink to `AGENTS.md` — the filename Claude Code looks for. | Claude Code |
| `settings.json` | Two safety **hooks** (block reading `.env`/key/credential files; auto-format edited files) + an empty permission allowlist. | Claude Code |
| `bootstrap.sh` | New-machine setup: clone/adopt `~/.claude`, link skills, print next steps. | Claude Code |
| `.github/workflows/` | Optional CI that reviews PRs against the four pillars. No-ops safely until a credential secret exists. | GitHub |
| `memory/`, `skills/` | Scaffolds for persistent memories and user-level skills. | Claude Code |

Everything below the `AGENTS.md` row is a **Claude Code bonus** — useful if you run Claude Code, ignorable otherwise. The instructions themselves are universal.

## Full Claude Code setup (optional)

To use the whole thing as your Claude Code home:

1. Install prerequisites: [Claude Code](https://claude.com/claude-code), plus `git`, `jq`, `node` (macOS: `brew install git jq node`).
2. Install it as your `~/.claude`:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/YOU/YOUR-REPO/main/bootstrap.sh | bash -s -- https://github.com/YOU/YOUR-REPO.git
   ```
   Idempotent and non-destructive — backs up anything it touches and adopts an existing `~/.claude`.
3. Start a new Claude Code session.

## The four pillars

Every piece of code, app, or infrastructure is held to **Security · Stability · Reliability · Compliance** — industry best practice, not personal taste. They're the default in `AGENTS.md` and the rubric the optional CI review uses. Edit them if your team's standard differs.

## Enabling the CI review (optional, Claude Code)

The workflow stays dormant (green no-op) until you add a credential secret per repo:

- **Claude Pro/Max** (no per-token billing): `claude setup-token`, then `gh secret set CLAUDE_CODE_OAUTH_TOKEN -R YOU/REPO`
- **Or an API key:** `gh secret set ANTHROPIC_API_KEY -R YOU/REPO`

Also install the [Claude GitHub App](https://github.com/apps/claude). The workflow runs only on non-draft, same-repo PRs with comment-only tools.

## Customizing

- **`AGENTS.md`** — the placeholders are the minimum; add your stack conventions, repo patterns, and an optional brand/voice SSOT pointer (a commented template is included).
- **`settings.json`** (Claude Code) — grow `permissions.allow`; tweak or remove either hook. The auto-format hook assumes Prettier.
- **Scheduled routines, MCP servers, plugins** are personal — add them on your machine; they aren't part of this shared template.

## License

MIT — see [LICENSE](LICENSE). Use it, fork it, make it your team's standard.
