otelcol::receiver { 'otlp' :
  config    => {
    'protocols' => {
      'grpc' => { 'endpoint' => 'localhost:4319' },
      'http' => { 'endpoint' => 'localhost:4320' },
    },
  },
  pipelines => ['metrics'],
}

otelcol::receiver { 'prometheus' :
  config    => {
    'config' => {
      'scrape_configs' => [
        {
          'job_name'        => 'otel-collector',
          'scrape_interval' => '10s',
          'static_configs'  => [
            { 'targets' => ['localhost:8889'] }
          ],
        },
      ],
    },
  },
  pipelines => ['metrics'],
}

otelcol::exporter { 'debug':
  config    => { 'verbosity' => 'detailed' },
  pipelines => ['metrics'],
}

otelcol::processor { 'batch':
  config    => {},
  pipelines => ['metrics'],
}

class { 'otelcol':
  manage_archive      => true,
  package_name        => 'otelcol-contrib',
  archive_version     => '0.132.4',
  telemetry_exporters => [{ 'prometheus' => { 'host' => '0.0.0.0', 'port' => 8889 } }],
}
