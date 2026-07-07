# tg-qa demo #1 — Telebook (Mini App + Telegram Stars)

A worked example of [tg-qa](https://github.com/c-c0rtex/tg-qa) testing a **Telegram
Mini App** bot end to end: the [Telebook](https://github.com/neSpecc/telebook) hotel-booking
bot (node-telegram-bot-api + a Vue Mini App), with payments switched to **Telegram Stars**.

It shows the parts of tg-qa that a Mini App needs:

- **Bot dialog testing** — commands, the Mini App button, replies and keyboards, snapshotted.
- **The Mini App bridge** — tg-qa resolves the web app's URL with a fresh, correctly-signed
  `initData` (via the user session) and hands it to Playwright, so the real Vue app runs in a
  headless browser under a genuine Telegram identity (`platform`, real user, valid signature).
- **Telegram Stars payments** — the demo patches Telebook's fiat flow to XTR, so invoices are
  created with no payment provider token at all.

## What the run proves

`tg-qa-run --project telebook` → **7/7 passed** (see [sample-reports/](sample-reports/)):
`/start` & `/help` show the welcome/help text and the Mini App button; arbitrary text and
unknown commands fall back to the app-launch prompt; the button survives new activity; the
help reply is never edited in place. The Mini App renders its real booking UI in headless
chromium ([sample-reports/miniapp.png](sample-reports/miniapp.png)).

## Findings (real bugs surfaced while wiring the demo)

- **`IS_TEST_ENVIRONMENT` conflates two concerns** in upstream Telebook — "listen on a local
  port" and "use Telegram's test data center". The demo adds a `FORCE_LISTEN` flag to listen
  locally without the test DC.
- **The Mini App SPA 404s on deep links / reloads** — the Vue router used `createWebHistory()`
  with no base while served under `/app/`. Fixed with `import.meta.env.BASE_URL` + a server-side
  SPA fallback.
- Telethon exposed a **Mini App button's URL only in the raw TL object** (fixed in tg-qa itself).

## Layout

```
setup.sh              clone Telebook @ pinned SHA, apply patches/, install, build
run.sh                cloudflared tunnel → build client against it → start server
patches/              the demo's diff over upstream Telebook (Stars, /app, listen, router base)
.env.example          documents the server env run.sh writes
.tg-qa/               committed test state: config, scenarios/, specs/, baseline/, bot.map.json, media/
sample-reports/       report.md, junit.xml, miniapp.png from a real run
```

## Run it yourself

1. `./setup.sh` — fetches Telebook at the pinned commit, applies the patches, installs & builds.
2. Create your own bot via [@BotFather](https://t.me/botfather); save its token to
   `~/.config/tg-qa/telebook.bot-token`. For payments, no provider token is needed (Stars).
3. Register the project with tg-qa (`tg-qa-register-project telebook --bot @your_bot …`), create
   a session (`tg-qa-login`), point `bot_source_dir` at the Telebook checkout.
4. `./run.sh` — brings the stand up behind a Cloudflare tunnel.
5. `tg-qa-mine --project telebook && tg-qa-run --project telebook --junit`.

> The tunnel URL is ephemeral; if it dies, re-run `run.sh` (the webhook re-registers).

## License

MIT — see [LICENSE](LICENSE). Telebook is © its authors (MIT); this repo vendors only a patch
against it, applied at setup time.
