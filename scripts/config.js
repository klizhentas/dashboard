{
  port: 8125,
  backends: [ "statsd-influxdb-backend" ],

  influxdb: {
    host: '127.0.0.1',   // InfluxDB host. (default 127.0.0.1)
    port: 8086,          // InfluxDB port. (default 8086)
    database: 'metrics',  // InfluxDB database instance. (required)
    username: 'metrics',    // InfluxDB database username. (required)
    password: 'metrics',    // InfluxDB database password. (required)
    flush: {
      enable: true       // Enable regular flush strategy. (default true)
    },
    proxy: {
      enable: false,       // Enable the proxy strategy. (default false)
      suffix: 'raw',       // Metric name suffix. (default 'raw')
      flushInterval: 1000  // Flush interval for the internal buffer.
                           // (default 1000)
    }
  }
}
