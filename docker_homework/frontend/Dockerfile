FROM node:14-alpine as builder
WORKDIR /app
COPY [ "package.json", "package-lock.json", "./" ]
RUN npm install
COPY ./ ./
RUN npm run build && npm install -g serve
EXPOSE 3000
CMD [ "serve", "-s", "build" ]
