# @summary Add a receiver to the OpenTelemetry Collector configuration
#
# @param name
#   The name of the receiver
# @param config
#   The configuration of the receiver
# @param order
#   The order of the receiver
# @param pipelines
#   The pipelines the receiver is part of
# @example
#   otelcol::receiver { 'namevar': }
define otelcol::receiver (
  Hash $config = {},
  Integer[0,999] $order = 0,
  Array[String[1]] $pipelines = [],
) {
  $real_order = 1000+$order
  otelcol::component { "${name}-receivers":
    order          => $real_order,
    config         => $config,
    pipelines      => $pipelines,
    component_name => $name,
    type           => 'receivers',
  }
}
