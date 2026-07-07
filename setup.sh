#!/usr/bin/env bash
# tg-qa demo #1 — Telebook (Mini App + Telegram Stars) stand setup.
#
# Clones the upstream Telebook bot at a pinned commit, applies the demo patches
# (local polling / listen, /app static + SPA fallback, Stars payments, router base)
# and builds server + client. Bring your OWN bot: create one via @BotFather and put
# its token where run.sh expects it (see README).
#
# Requirements: git, node >= 18, yarn, cloudflared (for run.sh).
set -euo pipefail
cd "$(dirname "$0")"

TELEBOOK_SHA="7e8c54398820a06e325be97e1e036d123e36c7e6"
SRC="${TELEBOOK_SRC:-$HOME/telebook}"

echo "== 1/4  Fetch Telebook @ ${TELEBOOK_SHA:0:12}"
if [ ! -d "$SRC/.git" ]; then
  git clone https://github.com/neSpecc/telebook "$SRC"
fi
git -C "$SRC" fetch --depth 1 origin "$TELEBOOK_SHA" 2>/dev/null || git -C "$SRC" fetch origin
git -C "$SRC" checkout -q "$TELEBOOK_SHA"

echo "== 2/4  Apply demo patches"
# Reset tracked files so the patch applies cleanly on re-run
git -C "$SRC" checkout -q -- .
git -C "$SRC" apply --verbose "$(pwd)/patches/tg-qa-demo.patch"

echo "== 3/4  Install dependencies (server + client)"
( cd "$SRC/server" && yarn install --frozen-lockfile )
( cd "$SRC/client" && yarn install --frozen-lockfile )

echo "== 4/4  Initial build (client re-built per-run against the tunnel URL)"
( cd "$SRC/server" && yarn build )

echo
echo "OK. Next:"
echo "  1. Create a bot via @BotFather, save its token to ~/.config/tg-qa/telebook.bot-token"
echo "  2. Register the tg-qa project (see README), then: ./run.sh"
