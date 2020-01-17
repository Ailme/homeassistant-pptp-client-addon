FROM alpine:edge

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk upgrade --no-cache --no-progress && \
    apk add --no-cache --no-progress \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    jq pptpclient bash \
    rm -rf /tmp/*

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]