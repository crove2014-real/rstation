#!/bin/sh
set -eu

# 确保配置目录存在
mkdir -p /etc/xray

PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/ws}"
UUID="${UUID:-$(cat /proc/sys/kernel/random/uuid)}"

DOMAIN="${RAILWAY_PUBLIC_DOMAIN:-}"
DOMAIN="${DOMAIN#https://}"
DOMAIN="${DOMAIN#http://}"
DOMAIN="${DOMAIN%%/*}"

cat > /etc/xray/config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${UUID}"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${WS_PATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

echo "=============================================="
echo "       Railway VLESS 自动部署"
echo "=============================================="
echo "端口: ${PORT}"
echo "UUID: ${UUID}"
echo "WS路径: ${WS_PATH}"

if [ -n "${DOMAIN}" ]; then
    PATH_ENC=$(printf '%s' "${WS_PATH}" | sed 's#/#%2F#g')

    echo ""
    echo "========== VLESS 分享链接 =========="
    echo "vless://${UUID}@${DOMAIN}:443?encryption=none&security=tls&type=ws&host=${DOMAIN}&path=${PATH_ENC}&sni=${DOMAIN}#Railway-VLESS"
    echo "===================================="
else
    echo ""
    echo "⚠️ 未检测到 Railway 公网域名。"
    echo "请进入 Railway → Service → Settings → Networking → Generate Domain"
    echo "生成域名后重新部署。"
fi

echo ""
echo "检查 Xray 配置..."
/usr/local/bin/xray run -test -c /etc/xray/config.json

echo "Xray 配置检查通过，正在启动..."
exec /usr/local/bin/xray run -c /etc/xray/config.json
