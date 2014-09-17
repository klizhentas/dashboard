FROM         ubuntu:12.04
MAINTAINER   Alexander Klizhentas klizhentas@gmail.com

RUN apt-get update
RUN apt-get -y install tar wget nodejs npm supervisor curl nginx netcat-openbsd

RUN cd /tmp && wget http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb && dpkg -i influxdb_latest_amd64.deb
RUN cd /tmp && wget https://github.com/etsy/statsd/archive/v0.7.2.tar.gz && tar -xzf v0.7.2.tar.gz && mv /tmp/statsd-0.7.2/ /opt/statsd

RUN echo "RESET 4"
RUN cd /tmp && wget http://grafanarel.s3.amazonaws.com/grafana-1.8.0-rc1.tar.gz && tar -xzf grafana-1.8.0-rc1.tar.gz && mv /tmp/grafana-1.8.0-rc1 /opt/grafana

RUN npm config set registry http://registry.npmjs.org/
RUN npm install statsd-influxdb-backend

ADD ./scripts /scripts
RUN rm -f /opt/grafana/config.sample.js
RUN mv /scripts/grafana.js /opt/grafana/config.js
RUN mv /scripts/default.conf /etc/nginx/conf.d/default.conf
RUN mv /scripts/nginx.conf /etc/nginx/nginx.conf
RUN mv /scripts/supervisor.conf /etc/supervisor/conf.d
RUN mkdir -p /var/influxdb
RUN chown -R www-data:www-data /opt/statsd /scripts /opt/grafana /var/influxdb

RUN /usr/bin/influxdb -config=/scripts/config.toml& \
    while ! nc -vz localhost 8086;do sleep 1; done && \
    curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{"name": "metrics"}' && \
    curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{"name": "grafana"}' && \
    curl -X POST 'http://localhost:8086/db/metrics/users?u=root&p=root' -d '{"name": "metrics", "password": "metrics"}' &&\
    curl -X POST 'http://localhost:8086/db/grafana/users?u=root&p=root' -d '{"name": "metrics", "password": "metrics"}' &&\
    kill $(pidof influxdb)



EXPOSE 8083 8086 2004 80 8125/udp
CMD exec supervisord -n
