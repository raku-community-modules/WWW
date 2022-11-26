FROM jjmerelo/raku-test:latest

USER root
RUN apk update && apk upgrade && apk add --no-cache openssl-dev
USER raku

WORKDIR /home/raku

COPY META6.json .

RUN zef install --deps-only . && rm META6.json

ENTRYPOINT ["zef","--debug","test","."]
