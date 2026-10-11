# Telegram MCP (plan, not implemented yet)

Run [chigwell/telegram-mcp](https://github.com/chigwell/telegram-mcp) on the server and connect it to Claude Code, so Claude can search and summarise Telegram chats.

## What it is

- An MCP server built on Telethon. Apache 2.0, about 1.8k stars.
- It logs in as a **user account**, not a bot: an API ID and hash from my.telegram.org, plus a session string or session file.
- 80+ tools:
  - read and search chats, history and contacts
  - send, edit, delete, forward, schedule and react
  - manage groups and channels (members, admins, bans)
  - folders and drafts
  - voice transcription
  - wait for new messages
- Transports: `stdio`, `http` (`/mcp`) or `sse`.

## Risks

- **The session is the whole account.** Anyone who has it can read every chat and send as you, and 2FA doesn't help. Revoke it under Telegram → Settings → Devices.
- **Prompt injection.** Every message Claude reads is text someone else wrote. Don't combine reading with send/forward/delete tools unless that's needed.
- **`TELEGRAM_EXPOSED_TOOLS=read-only` only hides tools from the client.** The session itself can still do everything.
- **Don't install `telegram-mcp` from PyPI.** It's an unrelated package. Build from the GitHub repo, pinned to a release tag.
- **The HTTP endpoint has no authentication.** Bind it to `127.0.0.1` only, and never put it on the Cloudflare tunnel.
- **Telegram's terms.** Automating a user account, especially sending in bulk, can get the account restricted.
- **Privacy.** Anything Claude reads from Telegram is sent to Anthropic as part of the conversation.

For notifications from the server (Seerr, diun, backups), use a Telegram **bot** instead. Bot tokens can't read personal chats.

## Plan

**In the repo**
- A `telegram-mcp/` folder with:
  - a `Dockerfile` that builds from the GitHub repo at a pinned tag
  - a `bootstrap.sh` that creates `~/home-server/telegram-mcp` and checks `.env`
- A service in `docker-compose.yaml` with:
  - `MCP_TRANSPORT=http` and a port bound to `127.0.0.1`
  - the session file persisted at `~/home-server/telegram-mcp`
- `TELEGRAM_API_ID` and `TELEGRAM_API_HASH` added to `.env` and `.env.example`.

**User steps (about 10 minutes)**
1. Create an app at my.telegram.org/apps, then put the API ID and hash in `.env`.
2. Run the interactive login once (QR code or phone code, plus the 2FA password) as a `!` command in Claude Code.

**Connect it to Claude Code**
- `claude mcp add --transport http telegram http://127.0.0.1:<port>/mcp`

**Restrictions**
- `TELEGRAM_EXPOSED_TOOLS=read-only` to start. Enable specific send tools later if needed.
- `TELEGRAM_ALLOWED_CHAT_IDS` to limit it to specific chats.
- `TELEGRAM_ALLOWED_ROOTS` to limit which folders files can be sent from.

## Open decisions

1. Read-only or with sending?
2. All chats, or a specific list of chat IDs?
