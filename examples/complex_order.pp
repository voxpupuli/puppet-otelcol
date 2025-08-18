Otelcol::Receiver { 'otlp' :
  config    => {
    'protocols' => {
      'grpc' => { 'endpoint' => 'localhost:4317' },
      'http' => { 'endpoint' => 'localhost:4318' },
    },
  },
  pipelines => ['metrics','logs'],
}

Otelcol::Receiver { 'prometheus' :
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

Otelcol::Exporter { 'debug':
  config    => { 'verbosity' => 'detailed' },
  pipelines => ['metrics','logs'],
}

Otelcol::Processor { 'batch/1':
  config    => {},
  pipelines => ['metrics','logs'],
  order     => 1,
}
Otelcol::Processor { 'memory_limiter/2':
  config    => { 'check_interval' => '5s', 'limit_mib' => 512 },
  pipelines => ['metrics','logs'],
  order     => 2,
}

class { 'otelcol':
  manage_archive => true,
}
