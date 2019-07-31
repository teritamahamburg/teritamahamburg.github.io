FROM node:12.7-alpine as build

ARG version=v1.3.2

RUN apk add --no-cache git \
    && git clone https://github.com/teritamahamburg/frontend.git --depth 1 -b ${version} \
    && git clone https://github.com/teritamahamburg/backend.git  --depth 1 -b ${version} \
    && cd frontend && npm install && npm run build && cd .. \
    && cd backend  && npm install && npm run build && cd .. \
    && mkdir teritama \
    && mv /frontend/dist /teritama/public \
    && mv /backend/dist  /teritama/dist \
    && mv /backend/src   /teritama/src \
    && mv /backend/package.json      /teritama \
    && mv /backend/package-lock.json /teritama

FROM node:12.7-alpine

LABEL maintainer="syuchan1005<syuchan.dev@gmail.com>"
LABEL name="TeritamaHamburg"

COPY --from=build /teritama /teritama

RUN cd /teritama && npm ci --only=production \
    && apk add --no-cache supervisor nginx

COPY nginx.conf /etc/nginx/
COPY supervisord.conf /etc/

EXPOSE 80

VOLUME ["/teritama/storage", "/teritama/production.sqlite"]

ENV DEBUG=""

CMD npm run db:migrate -- --env production; /usr/bin/supervisord
