class otelcol (
  String  $package_name                          = 'otelcol-contrib',
  String  $package_ensure                        = 'installed',
  String  $config_file                           = '/etc/otelcol-contrib/config.yaml',
  String  $config_file_owner                     = 'root',
  String  $config_file_group                     = 'root',
  Stdlib::Filemode $config_file_mode             = '0644',
  # String  $config_folder                         = $otelcol::params::config_folder,
  # Optional[Stdlib::Filemode] $config_folder_mode = $otelcol::params::config_folder_mode,
  Hash    $receivers                             = {
    'otlp': {
      'protocols': {
        'http': {},
        'grpc': {},
      }
    }
  },
  Hash    $processors                            = {},
  Hash    $exporters                             = {},
  Hash    $pipelines                             = {},
  Hash    $extensions                            = {},
  Boolean $manage_service                        = true,
  Boolean $manage_archive                        = false,
  Boolean $manage_user                           = false,
  Optional[String[1]] $archive_location          = 'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v',
  Optional[String[1]] $archive_version           = 0.74.0,
  Optional[String[1]] $archive_install_dir       = '/tmp',
  # Boolean $purge_config_fragments                = false,
  Stdlib::Ensure::Service  $service_ensure       = 'running',
  # Array   $install_options                       = '',
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
