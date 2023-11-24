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
    content => '# File Managed by Puppet',
  }

  concat::fragment { 'otelcol-config-baseconfig' :
    target  => 'otelcol-config',
    order   => 10000,
    content => stdlib::to_yaml($component),
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
      ensure_resource('otelcol::receiver', $rname, $rvalue)
    } else {
      ensure_resource('otelcol::receiver', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::processors.each|String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('otelcol::processor', $rname, $rvalue)
    } else {
      ensure_resource('otelcol::processor', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::exporters.each|String $rname, Hash $rvalue| {
    if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
      ensure_resource('otelcol::exporter', $rname, $rvalue)
    }
    else {
      ensure_resource('otelcol::exporter', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::pipelines.each|String $rname, Hash $rvalue| {
    if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
      ensure_resource('otelcol::pipeline', $rname, $rvalue)
    }
    else {
      ensure_resource('otelcol::pipeline', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::extensions.each|String $rname, Hash $rvalue| {
    if($rvalue['config'] and $rvalue['config'].is_a(Hash)) {
      ensure_resource('otelcol::extension', $rname, $rvalue)
    }
    else {
      ensure_resource('otelcol::extension', $rname, { 'config' => $rvalue })
    }
  }
}
