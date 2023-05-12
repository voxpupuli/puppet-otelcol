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
# @api private
class otelcol::service (
  Stdlib::Ensure::Service $ensure            = $otelcol::service_ensure,
) {
  # include install
  include otelcol::install

  # systemd::dropin_file { 'otelcol_service':
  #   unit     => 'otelcol.service',
  #   content  => epp('otelcol/otelcol.dropin.epp'),
  #   filename => 'otelcol_override.conf',
  # }
  # ~>
  service { 'otelcol':
    ensure    => $ensure,
    require   => Package['otelcol'],
    subscribe => [ File['otelcol-config'], File['otelcol-environment'] ],
  }
}
