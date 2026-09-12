# Railway VLESS 自动部署（修复版）

## 修复内容

- 自动创建 `/etc/xray`
- 启动前自动检查 Xray 配置
- 自动读取 Railway 公网域名
- 日志自动输出 `vless://` 分享链接
- 使用 VLESS + WebSocket

## 部署

1. 将本项目文件上传到 GitHub 仓库根目录。
2. Railway → New Project → Deploy from GitHub Repo。
3. 选择 GitHub 仓库。
4. Railway 自动读取 Dockerfile 并部署。
5. Railway → Service → Settings → Networking → Generate Domain。
6. 重新部署或等待服务重启。
7. Deployments → View Logs。
8. 找到 `VLESS 分享链接`，复制 `vless://` 开头的完整链接。

## 可选环境变量

UUID：不设置时启动自动生成。

WS_PATH：默认 `/ws`。

## 注意

Railway 公网 HTTPS/TLS 与容器内部的 WebSocket 服务分离。分享链接使用 Railway 的 HTTPS 域名。

日志中的链接表示配置已经生成并通过 Xray 配置检查；实际网络速度请在客户端中测试。
