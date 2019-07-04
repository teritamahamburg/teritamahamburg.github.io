FROM node:12-alpine as build

ARG version=v1.1.2

RUN apk add --no-cache git \
    && git clone https://github.com/teritamahamburg/frontend.git --depth 1 -b ${version} \
    && git clone https://github.com/teritamahamburg/backend.git  --depth 1 -b ${version} \
    && cd frontend && npm i && npm run build && cd .. \
    && cd backend  && npm i && npm run build && cd .. \
    && mkdir teritama \
    && mv /frontend/dist /teritama/public \
    && mv /backend/dist  /teritama/dist \
    && mv /backend/src   /teritama/src \
    && mv /backend/package.json      /teritama \
    && mv /backend/package-lock.json /teritama

FROM node:12-alpine

LABEL maintainer="syuchan1005<syuchan.dev@gmail.com>"
LABEL name="TeritamaHamburg"

COPY --from=build /teritama /teritama

WORKDIR /teritama

RUN npm ci --only=production

EXPOSE 80

VOLUME ["/teritama/storage", "/teritama/production.sqlite"]

ENV DEBUG="" PORT=80

CMD npm run db:migrate -- --env production; npm run start
