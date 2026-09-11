#!/bin/sh
set -eu
PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/ws}"
UUID="${UUID:-$(cat /proc/sys/kernel/random/uuid)}"
DOMAIN="${RAILWAY_PUBLIC_DOMAIN:-}"
DOMAIN="${DOMAIN#https://}"; DOMAIN="${DOMAIN#http://}"; DOMAIN="${DOMAIN%%/*}"
cat > /etc/xray/config.json <<EOF
{"log":{"loglevel":"warning"},"inbounds":[{"listen":"0.0.0.0","port":${PORT},"protocol":"vless","settings":{"clients":[{"id":"${UUID}"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"${WS_PATH}"}}}],"outbounds":[{"protocol":"freedom"}]}
EOF
echo "========== Railway VLESS =========="
echo "UUID: ${UUID}"
echo "WS路径: ${WS_PATH}"
if [ -n "${DOMAIN}" ]; then
  P=$(printf '%s' "${WS_PATH}" | sed 's#/#%2F#g')
  echo "vless://${UUID}@${DOMAIN}:443?encryption=none&security=tls&type=ws&host=${DOMAIN}&path=${P}&sni=${DOMAIN}#Railway-VLESS"
else
  echo "⚠️ 未检测到公网域名，请 Railway → Settings → Networking → Generate Domain"
fi
echo "==================================="
exec /usr/local/bin/xray run -c /etc/xray/config.json
