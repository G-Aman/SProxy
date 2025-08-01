FROM node:20-alpine AS base
WORKDIR /app

# Build layer
FROM base AS build

RUN npm i -g pnpm@8
COPY pnpm-lock.yaml package.json ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# Production layer
FROM base AS production

EXPOSE 3000
ENV NODE_ENV=production
COPY --from=build /app/.output ./.output

CMD ["node", ".output/server/index.mjs"]
