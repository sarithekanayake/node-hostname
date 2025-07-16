FROM node:24.4.0-alpine

WORKDIR /app

COPY package*.json ./

RUN --mount=type=cache,target=/app/.npm \
    npm set cache /app/.npm && \
    npm install 

USER node

COPY --chown=node:node . .

EXPOSE 3000

ENTRYPOINT [ "npm" ]

CMD ["start"]