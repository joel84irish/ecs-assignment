
FROM node:21-alpine AS build
COPY . .
WORKDIR /app

# Copy package files and install dependencies with Yarn 

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

# Copy all source files into the build container 
COPY . .

#RUN yarn build 
RUN yarn build

#Production stage
FROM alpine:latest

ENV NODE_ENV=production
ENV NEXT_OUTPUT_STANDALONE=true

WORKDIR /app

# Copy dependencies and build output from the build stage 
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/yarn.lock ./yarn.lock

RUN yarn install --frozen-lockfile

# Expose the port the app will run on 
EXPOSE 3000

RUN yarn global add serve

# Run the app using yarn start 
CMD ["serve", "-s", "build", "-l", "3000"]





