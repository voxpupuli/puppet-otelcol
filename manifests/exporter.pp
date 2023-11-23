# @summary Define a OpenTelemetry Collector exporter
#
# Create a OpenTelemetry Collector exporter in the configuration file.
#
# @param name
#  The name of the exporter.
# @param config
#  The configuration of the exporter.
# @param order
#  The order of the exporter.
# @param pipelines
#  The pipelines to attach the exporter to.
# @example
#   otelcol::exporter { 'namevar': }
define otelcol::exporter (
  Hash $config = {},
  Integer[0,999] $order = 0,
  Array[String[1]] $pipelines = [],
) {
  $real_order = 3000+$order
  Otelcol::Component { "${name}-exporter":
    order => $real_order,
    config => $config,
    pipelines => $pipelines,
    component_name => $name,
    type => 'exporters',
  }
}