## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
    * [Otelcol vs. Otelcol-contrib](#Otelcol-vs.-Otelcol-contrib)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)


[![Build Status](https://github.com/apa-it/puppet-otelcol/workflows/CI/badge.svg)](https://github.com/apa-it/puppet-otelcol/actions?query=workflow%3ACI)
[![Release](https://github.com/apa-it/puppet-otelcol/actions/workflows/release.yml/badge.svg)](https://github.com/apa-it/puppet-otelcol/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/otelcol.svg)](https://forge.puppetlabs.com/puppet/otelcol)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-otelcol)
[![Apache-2.0](https://img.shields.io/github/license/apa-it/puppet-otelcol.svg)](LICENSE)

## Description

This Module allows you to install and manage OpenTelemetry Collector https://opentelemetry.io/docs/collector/ 

Detailed Reference to all classparameters can be found in (https://github.com/apa-it/puppet-otelcol/blob/master/REFERENCE.md)
## Setup
The module allows you to address parts of configuration via hiera. Due to complexity there is currently no check of validity of the Otel configuration. 

If you don't have any kind of Package distribution System, you could use the Files directly from Github with the param manage_archive.
```puppet
  class { 'otelcol': 
    manage_archive => true
  }
```
### Otelcol vs. Otelcol-contrib
It is quite common to use Otelcol-Contrib, to do that it is enough to change the package_name to otelcol-contrib3
```puppet
  class { 'otelcol': 
    package_name => 'otelcol-contrib'
  }
```

## Limitations

Due to complexity there is currently no check of validity of the Otelcol configuration. 

## Development

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/apa-it/puppet-otelcol/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/puppetlabs/puppet-lint) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).
