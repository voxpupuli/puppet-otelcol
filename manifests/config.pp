# == Class: otelcol::config
#
# Templated generation of otelcol.conf
#
class otelcol::config inherits otelcol {
  assert_private()

  # due to inconsistent Naming in original packages, we need some handling here
  $package_default_username = ($otelcol::service_name) ? {
    'otelcol' => 'otel',
    default   => $otelcol::service_name,
  }
  $real_config_file_owner = ($otelcol::config_file_owner) ? {
    undef   => $package_default_username,
    default => $otelcol::config_file_owner
  }
  $real_config_file_group = ($otelcol::config_file_group) ? {
    undef   => $package_default_username,
    default => $otelcol::config_file_group
  }
  $proxy_host = $otelcol::proxy_host
  $proxy_port = $otelcol::proxy_port
  $metrics_readers = $otelcol::telemetry_exporters.map |Hash $hash_element| {
    $hash_element.map |String $name, Hash $value| {
      $type = $value ? {
        Otelcol::Telemetry_exporter::Pull     => 'pull',
        Otelcol::Telemetry_exporter::Periodic => 'periodic',
      }
      $element = { $type => { 'exporter' => { $name => $value } } }
      $element
    }
  }.flatten
  $component = {
    'service' => {
      'telemetry' => {
        'logs' => $otelcol::log_options,
        'metrics' => {
          'level' => $otelcol::metrics_level,
          'readers' => $metrics_readers,
        },
      },
    },
  }

  concat { 'otelcol-config' :
    ensure  => present,
    path    => $otelcol::config_file,
    format  => 'yaml',
    owner   => $real_config_file_owner,
    group   => $real_config_file_group,
    mode    => $otelcol::config_file_mode,
    require => Package['otelcol'],
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

  unless $facts['os']['family'] == 'windows' {
    file { 'otelcol-environment' :
      ensure  => 'file',
      path    => $otelcol::environment_file,
      content => template('otelcol/environment.conf.erb'),
      owner   => $real_config_file_owner,
      group   => $real_config_file_group,
      mode    => $otelcol::config_file_mode,
    }
    if $otelcol::manage_service {
      File['otelcol-environment'] ~> Service['otelcol']
    }
  }

  $otelcol::receivers.each |String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('otelcol::receiver', $rname, $rvalue)
    } else {
      ensure_resource('otelcol::receiver', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::processors.each |String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('otelcol::processor', $rname, $rvalue)
    } else {
      ensure_resource('otelcol::processor', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::exporters.each |String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('otelcol::exporter', $rname, $rvalue)
    }
    else {
      ensure_resource('otelcol::exporter', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::pipelines.each |String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('otelcol::pipeline', $rname, $rvalue)
    }
    else {
      ensure_resource('otelcol::pipeline', $rname, { 'config' => $rvalue })
    }
  }

  $otelcol::extensions.each |String $rname, Hash $rvalue| {
    if $rvalue['config'] =~ Hash {
      ensure_resource('otelcol::extension', $rname, $rvalue)
    }
    else {
      ensure_resource('otelcol::extension', $rname, { 'config' => $rvalue })
    }
  }
}
