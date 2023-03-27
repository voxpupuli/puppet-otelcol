# == Class: otelcol::install
#
# Conditionally handle repos or package paths and install the necessary
# otelcol package.
#
class otelcol::install {
  assert_private()

  case $facts['os']['family'] {
    'Debian': {
      archive { "/tmp/otelcol-${otelcol::archive_version}":
        ensure => present,
        source => 'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.74.0/otelcol-contrib_0.74.0_linux_amd64.deb',
        user   => 0,
        group  => 0,
      }
    }
    'RedHat': {
    }
    'windows': {
      # repo is not applicable to windows
    }
    default: {
      fail('Only RedHat, CentOS, OracleLinux, Debian, Ubuntu and Windows repositories are supported at this time')
    }
  }

  if ! $otelcol::manage_archive {
    ensure_packages([$otelcol::package_name],
      {
        ensure          => $otelcol::package_ensure,
        # install_options => $otelcol::install_options,
      }
    )
  }
}
