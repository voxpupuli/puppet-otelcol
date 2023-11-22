# @summary Add a pipeline to the OpenTelemetry Collector configuration
#
# Used for explicitly configuring a pipeline in the OpenTelemetry Collector.
# This is useful for configuring a pipeline that is not automatically
# configured by its Components.
#
# @param name
#   The name of the pipeline to configure.
# @param config
#   The configuration for the pipeline.
# @param order
#   The order in which the pipeline should be configured.  
# @example
#   otelcol::pipeline { 'namevar': }
define otelcol::pipeline (
  Hash $config = {},
  Integer[0,999] $order = 0,
) {
  $component = {
    'service' => {
      'pipelines' => {
        $name => $config,
      },
    },
  }
  $real_order = 5000+$order
  concat::fragment { "otelcol-config-pipeline-${name}" :
    target  => 'otelcol-config',
    order   => $real_order,
    content => template('otelcol/component.yml.erb'),
  }
}
