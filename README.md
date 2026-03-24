# puppet-otelcol

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
   - [Otelcol vs. Otelcol-contrib](#otelcol-vs-otelcol-contrib)
   - [Windows Support](#windows-support)
1. [Usage](#usage)
   - [Archive-based Installation](#archive-based-installation)
   - [Proxy Configuration](#proxy-configuration)
1. [Limitations](#limitations)
1. [Development](#development)

[![Build Status](https://github.com/voxpupuli/puppet-otelcol/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-otelcol/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-otelcol/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-otelcol/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-otelcol)
[![Apache-2.0](https://img.shields.io/github/license/voxpupuli/puppet-otelcol.svg)](LICENSE)
[![Donated by APA-TECH](https://img.shields.io/badge/donated%20by-APA%20TECH-005a78.svg)](#transfer-notice)

## Description

This Module allows you to install and manage [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/).

Detailed Reference to all class parameters can be found in [REFERENCE.md](https://github.com/voxpupuli/puppet-otelcol/blob/master/REFERENCE.md).

## Setup

The module allows you to address parts of configuration via hiera. Due to complexity there is currently no check of validity of the Otel configuration.

If you don't have any kind of Package distribution System, you could use the files directly from Github with the param `manage_archive`.

```puppet
class { 'otelcol':
  manage_archive => true,
}
```

### Otelcol vs. Otelcol-contrib

It is quite common to use Otelcol-Contrib, to do that it is enough to change the `package_name` to `otelcol-contrib`:

```puppet
class { 'otelcol':
  package_name => 'otelcol-contrib',
}
```

### Windows Support

This module supports Windows Server 2019 and 2022 in addition to Linux (Debian and RedHat families).

On Windows, the module installs the OpenTelemetry Collector via MSI package and manages it as a Windows service. The following platform-specific defaults are applied automatically via hiera:

| Setting           | Linux                             | Windows                                                |
| ----------------- | --------------------------------- | ------------------------------------------------------ |
| Config file path  | `/etc/<package_name>/config.yaml` | `C:/Program Files/OpenTelemetry Collector/config.yaml` |
| Config file owner | `<package_name>` (e.g. `otel`)    | `NT AUTHORITY\SYSTEM`                                  |
| Config file group | `<package_name>`                  | `Administrators`                                       |
| Config file mode  | `0600`                            | `0770`                                                 |
| Archive temp path | `/tmp`                            | `C:/Windows/Temp`                                      |

Basic Windows usage:

```puppet
class { 'otelcol':
  manage_archive => true,
}
```

Using otelcol-contrib on Windows:

```puppet
class { 'otelcol':
  package_name   => 'otelcol-contrib',
  manage_archive => true,
}
```

Note the following Windows-specific behaviors:

- The environment file (`otelcol-environment`) is **not managed** on Windows, as the Windows service does not use it.
- The MSI package registers the collector under its full display name, e.g. `OpenTelemetry Collector (0.135.0) - otelcol distribution`. The module handles this automatically.
- Configuration validation uses the `.exe` suffix on Windows (`otelcol.exe validate --config=...`).
- The `proxy_host` parameter has no effect on Windows (environment file is not managed).
- The `environment_file`, `run_options`, and `configs` parameters are not applicable on Windows.

## Usage

### Archive-based Installation

When `manage_archive` is enabled, the module downloads the appropriate package from the official OpenTelemetry Collector GitHub releases. The correct package format is selected automatically based on the OS family:

| OS Family | Package Format |
| --------- | -------------- |
| Debian    | `.deb`         |
| RedHat    | `.rpm`         |
| Windows   | `.msi`         |

You can pin a specific version using `archive_version`:

```puppet
class { 'otelcol':
  manage_archive  => true,
  archive_version => '0.132.4',
}
```

To use a custom download location, set `archive_location`:

```puppet
class { 'otelcol':
  manage_archive   => true,
  archive_location => 'https://my-mirror.example.com/otelcol_0.135.0_linux_amd64',
}
```

The file extension (`.deb`, `.rpm`, or `.msi`) is appended automatically based on the OS family.

### Proxy Configuration

On Linux, you can configure HTTP/HTTPS proxy settings that are written to the environment file:

```puppet
class { 'otelcol':
  proxy_host => '127.0.0.1',
  proxy_port => 8888,
}
```

This adds `HTTP_PROXY` and `HTTPS_PROXY` environment variables to the collector's environment file. This feature is only available on Linux.

## Limitations

- On Windows, the `environment_file`, `run_options`, `configs`, and `proxy_host`/`proxy_port` parameters are not supported.
- The `package_ensure` value `latest` is not supported on Windows.

## Development

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/voxpupuli/puppet-otelcol/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/puppetlabs/puppet-lint) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).
