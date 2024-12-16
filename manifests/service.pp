# @summary Manages the Otelcol service
#
# @example Make sure Otelcol is running
#   include 'otelcol::service'
#
# @example Disable otelcol service
#  class { 'otelcol::service':
#    ensure => stopped,
#  }
#
# @param ensure
#   Ensure service status
#
# @param enable
#   Enable service on boot
#
# @api private
class otelcol::service (
  Stdlib::Ensure::Service $ensure            = $otelcol::service_ensure,
  Boolean $enable                            = $otelcol::service_enable,
  String  $config_check_command              = "${otelcol::service_name} validate --config=${otelcol::config_file}",
  Boolean $config_check                      = $otelcol::service_configcheck,
) {
  # include install
  include otelcol::install

  if $config_check {
    exec { 'otelcol_config_check':
      command     => $config_check_command,
      refreshonly => true,
      path        => [
        '/usr/local/sbin',
        '/usr/local/bin',
        '/usr/sbin',
        '/usr/bin',
        '/sbin',
        '/bin',
      ],
    }
  }

  $service_require = $config_check ? {
    true => [Exec['otelcol_config_check'], Package['otelcol']],
    false => Package['otelcol'],
  }

  service { 'otelcol':
    ensure    => $ensure,
    enable    => $enable,
    name      => $otelcol::service_name,
    require   => $service_require,
    subscribe => [Concat['otelcol-config'], File['otelcol-environment']],
  }
}
