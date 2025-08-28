# @summary Installs and configures open telemetry collector

# @param package_name
#   Name of the package used
# @param package_ensure
#   Ensure for the package
# @param service_name
#   Name of the service used
# @param service_configcheck
#   Check config before service reloads
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
# @param configs
#   additional config files or resources to add. Since this can be environment variables, http urls or files
#   you are required to ensure the existence of a file!
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
# @param metrics_mode
#   Mode for metrics config either pull or push
# @param metrics_prometheus_host
#   Host for internal telemetry Prometheus metrics
# @param metrics_prometheus_port
#   Port for internal telemetry Prometheus metrics
# @param metrics_otlp_endpoint
#   OTLP endpoint for internal telemetry metrics
# @param metrics_otlp_protocol
#   OTLP protocol for internal telemetry metrics
# @param service_ensure
#   Ensure for service
# @param service_enable
#   Enable the service on boot
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
  Boolean $service_configcheck                   = true,
  String  $environment_file                      = "/etc/${package_name}/${package_name}.conf",
  Optional[String]  $run_options                 = undef,
  String  $config_file                           = "/etc/${package_name}/config.yaml",
  String  $config_file_owner                     = 'root',
  String  $config_file_group                     = 'root',
  Stdlib::Filemode $config_file_mode             = '0644',
  Array[String] $configs                         = [],
  Hash[String, Hash] $receivers = {},
  Hash[String, Hash] $processors = {},
  Hash[String, Hash] $exporters = {},
  Hash[String, Hash] $pipelines = {},
  Hash[String, Hash] $extensions = {},
  Variant[Hash,String[1]]    $log_options                            = {},
  Enum['pull','push'] $metrics_mode = 'pull',
  Enum['none','basic','normal','detailed'] $metrics_level = 'basic',
  Stdlib::Host $metrics_prometheus_host = '0.0.0.0',
  Stdlib::Port $metrics_prometheus_port = 8888,
  Stdlib::HTTPSUrl $metrics_otlp_endpoint = 'https://backend:4318',
  String[1] $metrics_otlp_protocol = 'http/protobuf',
  Stdlib::Ensure::Service $service_ensure       = 'running',
  Boolean $service_enable                        = true,
  Boolean $manage_service                        = true,
  Boolean $manage_archive                        = false,
  String[1] $localpath_archive                   = '/tmp',
  # Boolean $manage_user                           = false,
  String[1] $archive_version                     = '0.89.0',
  String[1] $archive_location          = "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${archive_version}/${package_name}_${archive_version}_linux_amd64",
  Optional[Stdlib::Host] $proxy_host = undef,
  Stdlib::Port $proxy_port = 8888,
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
