FROM node:13.6.0-alpine

ARG VERSION

LABEL org.opencontainers.image.title="App" \
      org.opencontainers.image.version=$VERSION

ADD app /usr/src/app
WORKDIR /usr/src/app
RUN npm install

USER node
CMD [ "npm", "start" ]