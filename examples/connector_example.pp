# Example using connectors to connect two pipelines
# Connectors are used to connect two pipelines together in OpenTelemetry Collector
# This example demonstrates the count connector converting traces to metrics

# Define a receiver for the traces pipeline
otelcol::receiver { 'foo':
  config    => {
    'protocols' => {
      'grpc' => { 'endpoint' => 'localhost:4317' },
    },
  },
  pipelines => ['traces'],
}

# Define a connector that counts traces and outputs metrics
# It acts as an exporter in the traces pipeline and a receiver in the metrics pipeline
otelcol::connector { 'count':
  config             => {},
  exporter_pipelines => ['traces'],
  receiver_pipelines => ['metrics'],
}

# Define an exporter for the traces pipeline
otelcol::exporter { 'bar':
  config    => {
    'endpoint' => 'localhost:9090',
  },
  pipelines => ['metrics'],
}

class { 'otelcol':
  manage_archive => true,
}
