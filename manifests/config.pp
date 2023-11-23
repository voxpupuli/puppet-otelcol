# == Class: otelcol::config
#
# Templated generation of otelcol.conf
#
class otelcol::config inherits otelcol {
  assert_private()
  $component = {
    'service' => {
      'telemetry' => {
        'logs' => $otelcol::log_options,
        'metrics' => {
          'level' => $otelcol::metrics_level,
          'address' => "${otelcol::metrics_address_host}:${otelcol::metrics_address_port}",
        },
      },
    },
  }

  concat { 'otelcol-config' :
    ensure => present,
    path   => $otelcol::config_file,
    format => 'yaml',
    owner  => $otelcol::config_file_owner,
    group  => $otelcol::config_file_group,
    mode   => $otelcol::config_file_mode,
  }
  concat::fragment { 'otelcol-config-header' :
    target  => 'otelcol-config',
    order   => 0,
    content => template('otelcol/config-header.yml.erb'),
  }

  concat::fragment { 'otelcol-config-baseconfig' :
    target  => 'otelcol-config',
    order   => 10000,
    content => stdlib::to_yaml($component),
  }

  concat::fragment { 'otelcol-config-footer' :
    target  => 'otelcol-config',
    order   => 10001,
    content => template('otelcol/config-footer.yml.erb'),
  }
  file { 'otelcol-environment' :
    ensure  => 'file',
    path    => $otelcol::environment_file,
    content => template('otelcol/environment.conf.erb'),
    owner   => $otelcol::config_file_owner,
    group   => $otelcol::config_file_group,
    mode    => $otelcol::config_file_mode,
  }

  $otelcol::receivers.each|String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('Otelcol::Receiver', $rname, $rvalue)
    } else {
      ensure_resource('Otelcol::Receiver', $rname, { 'config' => $rvalue })
    }
  }

  if($otelcol::processors) {
    $otelcol::processors.each|String $rname, Hash $rvalue| {
      if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
        ensure_resource('Otelcol::Processor', $rname, $rvalue)
      }
      else {
        ensure_resource('Otelcol::Processor', $rname, { 'config' => $rvalue })
      }
    }
  }

  if($otelcol::exporters) {
    $otelcol::exporters.each|String $rname, Hash $rvalue| {
      if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
        ensure_resource('Otelcol::Exporter', $rname, $rvalue)
      }
      else {
        ensure_resource('Otelcol::Exporter', $rname, { 'config' => $rvalue })
      }
    }
  }

  if($otelcol::pipelines) {
    $otelcol::pipelines.each|String $rname, Hash $rvalue| {
      if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
        ensure_resource('Otelcol::Pipeline', $rname, $rvalue)
      }
      else {
        ensure_resource('Otelcol::Pipeline', $rname, { 'config' => $rvalue })
      }
    }
  }

  if($otelcol::extensions) {
    $otelcol::extensions.each|String $rname, Hash $rvalue| {
      if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
        ensure_resource('Otelcol::Extension', $rname, $rvalue)
      }
      else {
        ensure_resource('Otelcol::Extension', $rname, { 'config' => $rvalue })
      }
    }
  }
}
