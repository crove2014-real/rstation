FROM ghcr.io/xtls/xray-core:latest AS xray

FROM alpine:3.22

COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray

RUN apk add --no-cache ca-certificates tzdata \
    && mkdir -p /etc/xray

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV PORT=8080
ENV WS_PATH=/ws

EXPOSE 8080

ENTRYPOINT ["/start.sh"]
