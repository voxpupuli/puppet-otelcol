# == Class: otelcol::config
#
# Templated generation of otelcol.conf
#
class otelcol::config inherits otelcol {
  assert_private()

  $settings = {
    'recievers' => $otelcol::receivers,
    'processors' => $otelcol::processors,
    'exporters' => $otelcol::exporters,
    'extensions' => $otelcol::extensions,
    'service' => {
      'extensions' => $otelcol::extensions.keys(),
      'pipelines' => $otelcol::pipelines,
    }
  }

  file { $otelcol::config_file:
    ensure  => 'file',
    content => template('otelcol/otelcol.conf.erb'),
    owner   => $otelcol::config_file_owner,
    group   => $otelcol::config_file_group,
    mode    => $otelcol::config_file_mode,
  }

  # file { $otelcol::config_folder:
  #   owner   => $otelcol::config_file_owner,
  #   group   => $otelcol::config_file_group,
  #   mode    => $otelcol::config_folder_mode,
  #   purge   => $otelcol::purge_config_fragments,
  #   recurse => true,
  #   ensure => 'directory',
  # }
}
