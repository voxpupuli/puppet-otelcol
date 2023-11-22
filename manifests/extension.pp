# @summary Add an extension to the OpenTelemetry Collector configuration
#
# @param name
#   The name of the extension
# @param config
#   The configuration for the extension
# @param order
#   The order in which the extension should be loaded
#
# @example
#   otelcol::extension { 'namevar': }
define otelcol::extension (
  Hash $config = {},
  Integer[0,999] $order = 0,
) {
  $component = {
    'extensions' => {
      $name => $config,
    },
    'service' => {
      'extensions' => [$name],
    },
  }
  $real_order = 4000+$order
  concat::fragment { "otelcol-config-extension-${name}" :
    target  => 'otelcol-config',
    order   => $real_order,
    content => template('otelcol/component.yml.erb'),
  }
}
