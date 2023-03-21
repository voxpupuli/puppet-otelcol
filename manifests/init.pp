class otelcol (
  String  $package_name                          = $otelcol::params::package_name,
  String  $ensure                                = $otelcol::params::ensure,
  String  $config_file                           = $otelcol::params::config_file,
  String  $config_file_owner                     = $otelcol::params::config_file_owner,
  String  $config_file_group                     = $otelcol::params::config_file_group,
  Optional[Stdlib::Filemode] $config_file_mode   = $otelcol::params::config_file_mode,
  String  $config_folder                         = $otelcol::params::config_folder,
  Optional[Stdlib::Filemode] $config_folder_mode = $otelcol::params::config_folder_mode,
  Hash    $receivers                             = $otelcol::params::receivers,
  Hash    $processors                            = {},
  Hash    $exporters                             = $otelcol::params::exporters,
  Boolean $manage_service                        = $otelcol::params::manage_service,
  Boolean $manage_repo                           = $otelcol::params::manage_repo,
  Boolean $manage_archive                        = $otelcol::params::manage_archive,
  Boolean $manage_user                           = $otelcol::params::manage_user,
  Optional[String] $repo_location                = $otelcol::params::repo_location,
  Optional[String] $archive_location             = $otelcol::params::archive_location,
  Optional[String[1]] $archive_version           = $otelcol::params::archive_version,
  Optional[String] $archive_install_dir          = $otelcol::params::archive_install_dir,
  Boolean $purge_config_fragments                = $otelcol::params::purge_config_fragments,
  String  $repo_type                             = $otelcol::params::repo_type,
  String  $windows_package_url                   = $otelcol::params::windows_package_url,
  Boolean $service_enable                        = $otelcol::params::service_enable,
  String  $service_ensure                        = $otelcol::params::service_ensure,
  Array   $install_options                       = $otelcol::params::install_options,
) inherits otelcol::params {
  $service_hasstatus = $otelcol::params::service_hasstatus
  $service_restart   = $otelcol::params::service_restart

  contain otelcol::install
  contain otelcol::config
  contain otelcol::service

  Class['otelcol::install'] -> Class['otelcol::config'] ~> Class['otelcol::service']
  Class['otelcol::install'] ~> Class['otelcol::service']
}
