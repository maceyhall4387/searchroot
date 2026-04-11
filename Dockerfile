FROM node:25-bookworm-slim AS install
USER node
WORKDIR /app/server

RUN git clone https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git /app/repo && \
    cp /app/repo/server/* . 2>/dev/null || true && \
    cp -r /app/repo/server/* . 2>/dev/null || true

COPY package.json package-lock.json ./

RUN --mount=type=cache,target=/home/node/.npm,uid=1000,gid=1000 \
    npm ci --omit=dev --no-audit --no-fund

FROM install AS build_node

RUN --mount=type=cache,target=/home/node/.npm,uid=1000,gid=1000 \
    npm ci --no-audit --no-fund

COPY types/ types/
COPY tsconfig.json ./
COPY src/ src/
RUN npx tsc

FROM install AS server_node

COPY --from=build_node /app/server/build /app/server/build

EXPOSE 4416
ENTRYPOINT ["/usr/local/bin/node", "build/main.js"]
