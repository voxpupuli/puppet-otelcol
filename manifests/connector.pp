# @summary Add a connector to the OpenTelemetry Collector configuration
#
# Connectors are used to connect two pipelines. A connector acts as both an exporter
# (at the end of one pipeline) and a receiver (at the start of another pipeline).
#
# @param name
#   The name of the connector
# @param config
#   The configuration of the connector
# @param order
#   The order of the connector
# @param exporter_pipelines
#   The pipelines where the connector is used as an exporter (data flows out)
# @param receiver_pipelines
#   The pipelines where the connector is used as a receiver (data flows in)
# @example basic connector
#   otelcol::connector { 'namevar': }
# @example Define a connector that converts traces to metrics
#   otelcol::connector { 'count':
#     exporter_pipelines => ['traces'],
#     receiver_pipelines => ['metrics'],
#   }
define otelcol::connector (
  Hash $config = {},
  Integer[0,999] $order = 0,
  Array[String[1]] $exporter_pipelines = [],
  Array[String[1]] $receiver_pipelines = [],
) {
  $real_order = 1500+$order

  # Define the connector in the connectors section
  $component = {
    'connectors' => {
      $name => $config,
    },
  }
  concat::fragment { "otelcol-config-connectors-${name}" :
    target  => 'otelcol-config',
    order   => $real_order,
    content => stdlib::to_yaml($component),
  }

  # Add connector as exporter to specified pipelines
  $exporter_pipelines.each |String $pipeline| {
    $exporter_component = {
      'service' => {
        'pipelines' => {
          $pipeline => {
            'exporters' => [$name],
          },
        },
      },
    }
    concat::fragment { "otelcol-config-connector-${name}-exporter-${pipeline}" :
      target  => 'otelcol-config',
      order   => $real_order,
      content => stdlib::to_yaml($exporter_component),
    }
  }

  # Add connector as receiver to specified pipelines
  $receiver_pipelines.each |String $pipeline| {
    $receiver_component = {
      'service' => {
        'pipelines' => {
          $pipeline => {
            'receivers' => [$name],
          },
        },
      },
    }
    concat::fragment { "otelcol-config-connector-${name}-receiver-${pipeline}" :
      target  => 'otelcol-config',
      order   => $real_order,
      content => stdlib::to_yaml($receiver_component),
    }
  }
}
