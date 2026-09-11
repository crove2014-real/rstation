# Railway VLESS 自动部署

GitHub → Railway → Docker → Xray。

1. 把文件上传到 GitHub 仓库根目录。
2. Railway → New Project → Deploy from GitHub Repo。
3. 选择仓库并部署。
4. Service → Settings → Networking → Generate Domain。
5. 重新部署/重启。
6. Deployments → View Logs。
7. 复制日志中的 `vless://` 链接。

默认 VLESS + WebSocket，内部监听 Railway 提供的 PORT，公网使用 Railway HTTPS 域名。

注意：日志中的链接表示配置已生成，不代表线路一定最快；请在 Shadowrocket 中实测。
