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
# @example Basic usage
#   otelcol::exporter { 'namevar': }
# @example Define a exporter and attach it to a pipeline
#   otelcol::exporter { 'prometheus':
#     pipelines => ['metrics'],
#   }
define otelcol::exporter (
  Hash $config = {},
  Integer[0,999] $order = 0,
  Array[String[1]] $pipelines = [],
) {
  $real_order = 3000+$order
  otelcol::component { "${name}-exporter":
    order          => $real_order,
    config         => $config,
    pipelines      => $pipelines,
    component_name => $name,
    type           => 'exporters',
  }
}
