# == Class: otelcol::params
#
# A set of default parameters for otelcol's configuration.
#
class otelcol::params {
  case $facts['os']['family'] {
    'windows': {
      $config_file          = 'C:/Program Files/otelcol/otelcol.conf'
      $config_file_owner    = 'Administrator'
      $config_file_group    = 'Administrators'
      $config_file_mode     = undef
      $config_folder        = 'C:/Program Files/otelcol/otelcol.d'
      $config_folder_mode   = undef
      $logfile              = 'C:/Program Files/otelcol/otelcol.log'
      $manage_repo          = false
      $manage_archive       = false
      $manage_user          = false
      $archive_install_dir  = undef
      $archive_location     = undef
      $archive_version      = undef
      $repo_location        = undef
      $service_enable       = true
      $service_ensure       = running
      $service_hasstatus    = false
      $service_restart      = undef
    }
    default: {
      $package_name         = 'otelcol-contrib'
      $config_file          = '/etc/otelcol/otelcol.conf'
      $config_file_owner    = 'otelcol'
      $config_file_group    = 'otelcol'
      $config_file_mode     = '0640'
      $logfile              = ''
      $manage_repo          = false
      $manage_archive       = true
      $manage_user          = false
      $archive_install_dir  = '/opt/otelcol'
      $archive_location     = "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${archive_version}/${package_name}_${archive_version}_linux_amd4.deb"
      $archive_version      = '0.74.0'
      $repo_location        = undef
      $service_enable       = true
      $service_ensure       = running
      $service_hasstatus    = true
      $service_restart      = 'pkill -HUP otelcol'
    }
  }
}
