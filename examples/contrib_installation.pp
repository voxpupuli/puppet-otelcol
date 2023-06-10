class { 'otelcol':
  manage_archive    => true,
  package_name      => 'otelcol-contrib',
  config_file_owner => 'otelcol-contrib',
  config_file_group => 'otelcol-contrib',
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
              { 'targets' => ['0.0.0.0:8888'] }
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
