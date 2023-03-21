# == Class: otelcol::config
#
# Templated generation of otelcol.conf
#
class otelcol::config inherits otelcol {
  assert_private()

  file { $otelcol::config_file:
    ensure  => $otelcol::ensure_file,
    content => template('otelcol/otelcol.conf.erb'),
    owner   => $otelcol::config_file_owner,
    group   => $otelcol::config_file_group,
    mode    => $otelcol::config_file_mode,
  }

  $_dir = $otelcol::ensure ? {
    'absent' => { ensure => 'absent', force => true },
    default  => { ensure => 'directory' }
  }

  file { $otelcol::config_folder:
    owner   => $otelcol::config_file_owner,
    group   => $otelcol::config_file_group,
    mode    => $otelcol::config_folder_mode,
    purge   => $otelcol::purge_config_fragments,
    recurse => true,
    *       => $_dir,
  }
}
