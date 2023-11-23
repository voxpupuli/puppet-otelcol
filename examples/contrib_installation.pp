otelcol::receiver { 'otlp' :
  config    => {
    'protocols' => {
      'grpc' => { 'endpoint' => 'localhost:4319' },
      'http' => { 'endpoint' => 'localhost:4320' },
    },
  },
  pipelines => ['metrics'],
}

Otelcol::Receiver { 'prometheus' :
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

Otelcol::Exporter { 'logging':
  config    => { 'verbosity' => 'detailed' },
  pipelines => ['metrics'],
}

Otelcol::Processor { 'batch':
  config    => {},
  pipelines => ['metrics'],
}

class { 'otelcol':
  manage_archive => true,
  package_name         => 'otelcol-contrib',
  metrics_address_port => 8889,
}
