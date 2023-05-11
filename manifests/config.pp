# == Class: otelcol::config
#
# Templated generation of otelcol.conf
#
class otelcol::config inherits otelcol {
  assert_private()

  $settings = {
    'receivers' => $otelcol::receivers,
    'processors' => $otelcol::processors,
    'exporters' => $otelcol::exporters,
    'extensions' => $otelcol::extensions,
    'service' => {
      'extensions' => $otelcol::extensions.keys(),
      'pipelines' => $otelcol::pipelines,
    },
  }

  file { 'otelcol-config' :
    ensure  => 'file',
    path    => $otelcol::config_file,
    content => template('otelcol/config.yml.erb'),
    owner   => $otelcol::config_file_owner,
    group   => $otelcol::config_file_group,
    mode    => $otelcol::config_file_mode,
  }
  file { 'otelcol-environment' :
    ensure  => 'file',
    path    => $otelcol::environment_file,
    content => template('otelcol/environment.conf.erb'),
    owner   => $otelcol::config_file_owner,
    group   => $otelcol::config_file_group,
    mode    => $otelcol::config_file_mode,
  }
}
