otelcol::receiver { 'otlp' :
  config    => {
    'protocols' => {
      'grpc' => { 'endpoint' => 'localhost:4317' },
      'http' => { 'endpoint' => 'localhost:4318' },
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
            { 'targets' => ['localhost:8888'] }
          ],
        },
      ],
    },
  },
  pipelines => ['metrics'],
}

otelcol::exporter { 'logging':
  config    => { 'verbosity' => 'detailed' },
  pipelines => ['metrics'],
}

otelcol::processor { 'batch':
  config    => {},
  pipelines => ['metrics'],
}

class { 'otelcol':
  manage_archive => true,
}
