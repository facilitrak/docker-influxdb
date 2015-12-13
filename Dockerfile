FROM quay.io/facilitrak/consul

ENV INFLUXDB_VERSION 0.9.6.1
ENV CONFIG_FILE /etc/influxdb/config.toml
ENV GOPATH /build
RUN apk --update add bzr git go mercurial tar \
    && go get github.com/influxdb/influxdb \
    && cd $GOPATH/src/github.com/influxdb/influxdb \
    && git checkout v${INFLUXDB_VERSION} \
    && cd $GOPATH/src/github.com/influxdb \
    && go get ./... \
    && go install ./... \
    && mv $GOPATH/bin/* /bin/ \
    && mkdir -p /etc/influxdb \
    && mv $GOPATH/src/github.com/influxdb/influxdb/etc/config.sample.toml $CONFIG_FILE \
    && rm -Rf /build \
    && apk del bzr git go mercurial tar \
    && rm -rf /var/cache/apk/*

COPY consul.json /etc/consul/
COPY run-influx /bin/

VOLUME /var/lib/influxdb/data
EXPOSE 8083 8086 8088

CMD ["run-influx"]
