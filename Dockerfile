# Build stage
FROM --platform= node:18-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install 
COPY . .
RUN yarn build

# Production stage
FROM node:18-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/yarn.lock ./yarn.lock
RUN yarn install 
EXPOSE 3000
CMD ["npx", "serve", "-s", "build", "-l", "3000"]