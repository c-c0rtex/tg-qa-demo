#!/usr/bin/env bash
# tg-qa demo #1 — Telebook: bring the stand up behind a Cloudflare tunnel.
#
# A Mini App bot needs a public HTTPS host for its webhook AND for the web app.
# We use an ephemeral `cloudflared` quick tunnel: when it dies, the webhook dies —
# just re-run this script. The client is rebuilt per run because the tunnel URL is
# baked into it at build time (VITE_* hosts).
#
# Prereqs: ./setup.sh done, a bot token at ~/.config/tg-qa/telebook.bot-token.
set -euo pipefail
cd "$(dirname "$0")"

SRC="${TELEBOOK_SRC:-$HOME/telebook}"
PORT="${PORT:-3400}"
TOKEN_FILE="$HOME/.config/tg-qa/telebook.bot-token"
[ -f "$TOKEN_FILE" ] || { echo "missing $TOKEN_FILE — create a bot via @BotFather first"; exit 1; }

echo "== Start cloudflared tunnel → localhost:$PORT"
TUN_LOG="$(mktemp)"
cloudflared tunnel --url "http://localhost:$PORT" --no-autoupdate >"$TUN_LOG" 2>&1 &
TUN_PID=$!
trap 'kill $TUN_PID 2>/dev/null || true' EXIT
for _ in $(seq 1 30); do
  URL=$(grep -o 'https://[a-z0-9-]*\.trycloudflare\.com' "$TUN_LOG" | head -1 || true)
  [ -n "${URL:-}" ] && break
  sleep 1
done
[ -n "${URL:-}" ] || { echo "tunnel URL not found; see $TUN_LOG"; exit 1; }
echo "   tunnel: $URL"

echo "== Build client against the tunnel URL (base=/app/)"
( cd "$SRC/client"
  printf 'VITE_WEB_HOST=%s/app\nVITE_API_HOST=%s\n' "$URL" "$URL" > .env
  npx vite build --base=/app/ >/dev/null
  cp -r dist/* "$SRC/server/public/app/"
  cp -r dist/* "$SRC/server/dist/public/app/" )

echo "== Write server .env (Stars payments, webhook via tunnel, force local listen)"
umask 077
cat > "$SRC/server/.env" <<EOF
BOT_TOKEN=$(cat "$TOKEN_FILE")
WEB_APP_URL=$URL/app/
APP_NAME=Telebook
PORT=$PORT
USE_POLLING=false
FORCE_LISTEN=true
PUBLIC_HOST=$URL
PROVIDER_TOKEN=
EOF

echo "== Run server (Ctrl-C to stop; tunnel stops with it)"
( cd "$SRC/server" && node dist/src/index.js )
