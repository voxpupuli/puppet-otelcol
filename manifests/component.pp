# @summary Define a component for the OpenTelemetry Collector Configuration
#
# Generic Type for defining a component for the OpenTelemetry Collector Configuration
#
# @param component_name
#   The name of the component
# @param type
#   The type of the component
# @param config
#   The configuration for the component
# @param order
#   The order of the component
# @param pipelines
#   The pipelines to add the component to
#
# @example
#   otelcol::component { 'receiver_name-receiver':': 
#     component_name => 'receiver_name',
#     type           => 'receiver',
# }
# @api private
define otelcol::component (
  String $component_name,
  String $type,
  Hash $config = {},
  Integer[0,10999] $order = 0,
  Array[String[1]] $pipelines = [],
) {
  # assert_private()
  $component = {
    $type => {
      $component_name => $config,
    },
  }
  concat::fragment { "otelcol-config-${type}-${component_name}" :
    target  => 'otelcol-config',
    order   => $order,
    content => stdlib::to_yaml($component),
  }

  $pipelines.each |String $pipeline| {
    $component = {
      'service' => {
        'pipelines' => {
          $pipeline => {
            $type => [$component_name],
          },
        },
      },
    }
    concat::fragment { "otelcol-config-${type}-${component_name}-${pipeline}" :
      target  => 'otelcol-config',
      order   => $order,
      content => stdlib::to_yaml($component),
    }
  }
}
