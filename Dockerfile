FROM node:12.10-alpine as build

ARG version=v1.3.7

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

FROM node:12.10-alpine

LABEL maintainer="syuchan1005<syuchan.dev@gmail.com>"
LABEL name="TeritamaHamburg"

EXPOSE 80

ENV DEBUG=""

RUN apk add --no-cache supervisor=3.3.4-r1 nginx=1.14.2-r4 \
    && mkdir /teritama

COPY --from=build ["/teritama/package.json", "/teritama/package-lock.json", "/teritama/"]

WORKDIR /teritama

RUN npm ci --only=production

COPY nginx.conf /etc/nginx/
COPY supervisord.conf /etc/

COPY --from=build /teritama /teritama

# "/teritama/production.sqlite" is file
VOLUME ["/teritama/storage"]

CMD npm run db:migrate -- --env production; /usr/bin/supervisord
