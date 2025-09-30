# == Class: otelcol::install
#
# Conditionally handle repos or package paths and install the necessary
# otelcol package.
#
# @param archive_location
#   Path to archive without filetype extension
#
class otelcol::install (
  $archive_location,
) {
  assert_private()

  if $otelcol::manage_archive {
    case $facts['os']['family'] {
      'Debian': {
        $archive_source = "${archive_location}.deb"
      }
      'RedHat': {
        $archive_source = "${archive_location}.rpm"
      }
      'windows': {
        $archive_source = "${archive_location}.msi"
      }
      default: {
        fail('Only RedHat, CentOS, OracleLinux, Debian, Ubuntu and Windows repositories are supported at this time')
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

  # Windows identifies the package by its full name including version and distribution
  if $facts['os']['family'] == 'windows' {
    $package_name = "OpenTelemetry Collector (${otelcol::archive_version}) - ${otelcol::package_name} distribution"
  } else {
    $package_name = $otelcol::package_name
  }

  package { 'otelcol':
    ensure => $otelcol::package_ensure,
    name   => $package_name,
    source => $package_source,
  }
}
