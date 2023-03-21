# == Class: otelcol::install
#
# Conditionally handle repos or package paths and install the necessary
# otelcol package.
#
class otelcol::install {
  assert_private()

  case $facts['os']['family'] {
    'Debian': {
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

  if $facts['os']['family'] == 'windows' {
    # required to install otelcol on windows
    require chocolatey

    # package install
    package { $otelcol::package_name:
      ensure          => $otelcol::ensure,
      provider        => chocolatey,
      source          => $otelcol::windows_package_url,
      install_options => $otelcol::install_options,
    }
  } else {
    if ! $otelcol::manage_archive {
      ensure_packages([$otelcol::package_name],
        {
          ensure          => $otelcol::ensure,
          install_options => $otelcol::install_options,
        }
      )
    }
  }
}
