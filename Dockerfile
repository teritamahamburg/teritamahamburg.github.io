FROM node:12-alpine as build

ARG version=v1.0.0

RUN apk add --no-cache git \
    && git clone https://github.com/teritamahamburg/frontend.git --depth 1 -b ${version} \
    && git clone https://github.com/teritamahamburg/backend.git  --depth 1 -b ${version} \
    && cd frontend && npm i && npm run build && cd .. \
    && cd backend  && npm i && npm run build && cd ..

FROM node:12-alpine

LABEL maintainer="syuchan1005<syuchan.dev@gmail.com>"
LABEL name="TeritamaHamburg"

COPY --from=build /frontend/dist        /teritama/public
COPY --from=build /backend/dist         /teritama/dist
COPY --from=build /backend/package.json      /teritama
COPY --from=build /backend/package-lock.json /teritama

WORKDIR /teritama

RUN npm ci --only=production

CMD ["DEBUG=", "PORT=80", "npm", "run", "start"]
