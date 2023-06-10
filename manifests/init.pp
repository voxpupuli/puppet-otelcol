# @summary Installs and configures open telemetry collector

# @param package_name
#   Name of the package used
# @param package_ensure
#   Ensure for the package
# @param service_name
#   Name of the service used
# @param environment_file
#   path of the environment file used for service
# @param run_options
#   additional options for service
# @param config_file
#   path to config file
# @param config_file_owner
#   owner of config_file
# @param config_file_group
#   group of config_file
# @param config_file_mode
#   mode of config_file
# @param receivers
#   Hash for receivers config
# @param processors
#   Hash for processors config
# @param exporters
#   Hash for exporters config
# @param pipelines
#   Hash for pipelines config
# @param extensions
#   Hash for extensions config
# @param log_options
#   Hash for log_options config
# @param metrics_level
#   Level for metrics config
# @param metrics_address_host
#   Host metrics are listening to
# @param metrics_address_port
#   Port metrics are listening to
# @param manage_service
#   If service is managed by module
# @param manage_archive
#   If archive should be managed by module of will be provided by packagemanager
# @param localpath_archive
#   Path where archive will be stored if managed
# @param archive_version
#   Version of otelcol that will be used, param is not used if archive_location is set
# @param archive_location
#   Path to archive without filetype extension
class otelcol (
  String  $package_name                          = 'otelcol',
  Enum['present','absent','installed','latest']  $package_ensure       = 'installed',
  String  $service_name                          = $package_name,
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
  Variant[Hash,String[1]]    $processors                            = {},
  Variant[Hash,String[1]]    $exporters                             = {},
  Variant[Hash,String[1]]    $pipelines                             = {},
  Hash    $extensions                            = {},
  Variant[Hash,String[1]]    $log_options                            = {},
  Enum['none','basic','normal','detailed'] $metrics_level = 'basic',
  Optional[Stdlib::Host] $metrics_address_host    = undef,
  Stdlib::Port $metrics_address_port             = 8888,
  Stdlib::Ensure::Service  $service_ensure       = 'running',
  Boolean $manage_service                        = true,
  Boolean $manage_archive                        = false,
  String[1] $localpath_archive                   = '/tmp',
  # Boolean $manage_user                           = false,
  String[1] $archive_version                     = '0.79.0',
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
