#!/usr/bin/env bash
# Swap the NoctaProton VPN bar icon from shields to keys.
# Noctalia rewrites plugin files when it fetches plugin updates, so
# protonvpn-key-icon.path re-runs this whenever bar.luau changes.
# Safe to run repeatedly: it only edits lines that still say "shield".

f="$HOME/.local/state/noctalia/plugins/materialized/community/noctaproton-vpn/bar.luau"
[ -f "$f" ] || exit 0
grep -q '"shield' "$f" || exit 0

sed -i \
  -e 's/local glyphName = "shield-lock"/local glyphName = "key"/' \
  -e 's/glyphName = "shield-check"/glyphName = "key-filled"/' \
  -e 's/glyphName = "shield"$/glyphName = "key"/' \
  "$f"
