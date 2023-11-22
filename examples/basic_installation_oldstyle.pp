class { 'otelcol':
  manage_archive => true,
  receivers      => {
    'otlp'       => {
      'protocols' => {
        'grpc' => { 'endpoint' => 'localhost:4317' },
        'http' => { 'endpoint' => 'localhost:4318' },
      },
    },
    'prometheus' => {
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
  },
  exporters      => { 'logging' => { 'verbosity' => 'detailed' } },
  pipelines      => {
    'metrics' => {
      'receivers'  => ['otlp', 'prometheus'],
      'processors' => ['batch'],
      'exporters'  => ['logging'],
    },
  },
  processors     => { 'batch' => {} },
}
