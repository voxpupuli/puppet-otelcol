# == Class: otelcol::install
#
# Conditionally handle repos or package paths and install the necessary
# otelcol package.
#
class otelcol::install {
  assert_private()

  if $otelcol::manage_archive {
    case $facts['os']['family'] {
      'Debian': {
        $archive_source = "${otelcol::archive_location}.deb"
      }
      'RedHat': {
        $archive_source = "${otelcol::archive_location}.rpm"
      }
      default: {
        fail('Only RedHat, CentOS, OracleLinux, Debian, Ubuntu repositories are supported at this time')
      }
    }
    $package_source = "${otelcol::localpath_archive}/${archive_source.split('/')[-1]}"
    file { 'otelcol_package':
      path   => $package_source,
      source => $archive_source,
      notify => Package['otelcol'],
    }
  }
  else {
    $package_source = undef
  }

  package { 'otelcol':
    ensure => $otelcol::package_ensure,
    name   => $otelcol::package_name,
    source => $package_source,
  }
}
