# Use a specific, pinned version of Node.js (v24.4.0) based on Alpine Linux
# Avoids potential issues from using 'latest', ensuring consistent builds across environments
FROM node:24.4.0-alpine

WORKDIR /app

COPY src/package*.json ./


# Install dependencies using a mount cache for npm:
# - Mounts a temporary volume at /app/.npm to cache installed packages between builds
# - Avoids re-downloading packages unnecessarily, speeding up rebuilds
RUN --mount=type=cache,target=/app/.npm \
    npm set cache /app/.npm && \
    npm install 

# Switch to a non-root user (node uid:1000) for better security
USER 1000

COPY --chown=node:node src/ .

# Expose node-hostname app on port 3000
EXPOSE 3000

ENTRYPOINT [ "npm" ]

CMD ["start"]