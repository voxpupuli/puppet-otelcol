class otelcol (
  String  $package_name                          = 'otelcol',
  Stdlib::Ensure::Package  $package_ensure       = 'installed',
  String  $environment_file                      = "/etc/${package_name}/${package_name}.conf",
  Optional[String]  $run_options                 = undef,
  String  $config_file                           = "/etc/${package_name}/config.yaml",
  String  $config_file_owner                     = $package_name,
  String  $config_file_group                     = $package_name,
  Stdlib::Filemode $config_file_mode             = '0640',
  Hash    $receivers                             = {
    'otlp' => {
      'protocols' => {
        'http' => {},
        'grpc' => {},
      },
    },
  },
  Hash    $processors                            = {},
  Hash    $exporters                             = {},
  Hash    $pipelines                             = {},
  Hash    $extensions                            = {},
  Stdlib::Ensure::Service  $service_ensure       = 'running',
  Boolean $manage_service                        = true,
  Boolean $manage_archive                        = false,
  # Boolean $manage_user                           = false,
  String[1] $archive_version                     = '0.77.0',
  String[1] $archive_location          = "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${archive_version}/${package_name}_${archive_version}_linux_amd64",
) {
  contain otelcol::install
  contain otelcol::config
  if($manage_service) {
    contain otelcol::service
    Class['otelcol::config'] ~> Class['otelcol::service']
    Class['otelcol::install'] ~> Class['otelcol::service']
  }

  Class['otelcol::install'] -> Class['otelcol::config']
}
