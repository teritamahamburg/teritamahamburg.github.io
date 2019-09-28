# TeritamaHamburg

[![shields.io](https://img.shields.io/badge/latest-v1.3.9-brightgreen?style=for-the-badge)](https://hub.docker.com/r/syuchan1005/teritama)

[![dockeri.co](https://dockeri.co/image/syuchan1005/teritama)](https://hub.docker.com/r/syuchan1005/teritama)

## Docker
```bash
docker run \
    -p 80 \
    -v /{Your path}/storage:/teritama/storage \
    -v /{Your path}/production.sqlite:/teritama/production.sqlite \
    syuchan1005/teritama:1.3.9
```
