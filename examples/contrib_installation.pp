class { 'otelcol':
  manage_archive    => true,
  package_name      => 'otelcol-contrib',
  metrics_address_port => 8889,
  receivers         => {
    'otlp'       => {
      'protocols' => {
        'grpc' => { 'endpoint' => 'localhost:4319' },
        'http' => { 'endpoint' => 'localhost:4320' },
      },
    },
    'prometheus' => {
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
  },
  exporters         => { 'logging' => { 'verbosity' => 'detailed' } },
  pipelines         => {
    'metrics' => {
      'receivers' => ['otlp', 'prometheus'],
      'exporters' => ['logging'],
    },
  },
  processors        => { 'batch' => {} },
}
