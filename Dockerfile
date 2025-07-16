FROM node:24.4.0-alpine

WORKDIR /app

COPY src/package*.json ./

RUN --mount=type=cache,target=/app/.npm \
    npm set cache /app/.npm && \
    npm install 

USER node

COPY --chown=node:node src/ .

EXPOSE 3000

ENTRYPOINT [ "npm" ]

CMD ["start"]