FROM node:20-alpine

WORKDIR /app

# Install git
RUN apk add --no-cache git

# Clone the repository
RUN git clone --single-branch --branch 1.3.1 https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git . && \
    cd server && \
    npm ci && \
    npx tsc

WORKDIR /app/server

# Expose port 10000
EXPOSE 10000

# Run the server on port 10000
CMD ["node", "build/main.js", "--port", "10000"]
