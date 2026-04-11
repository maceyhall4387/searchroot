FROM node:25-bookworm-slim AS install
USER node
WORKDIR /app/server

RUN git clone https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git /tmp/repo && \
    cp -r /tmp/repo/server/* .

RUN --mount=type=cache,target=/home/node/.npm,uid=1000,gid=1000 \
    npm ci --omit=dev --no-audit --no-fund

FROM install AS build_node

RUN --mount=type=cache,target=/home/node/.npm,uid=1000,gid=1000 \
    npm ci --no-audit --no-fund

RUN npx tsc

FROM install AS server_node

COPY --from=build_node /app/server/build /app/server/build

EXPOSE 4416
ENTRYPOINT ["/usr/local/bin/node", "build/main.js"]
