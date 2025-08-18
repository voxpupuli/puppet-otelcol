type Otelcol::Telemetry_exporter = Variant[
  Struct[{ 'prometheus' => Otelcol::Telemetry_exporter::Pull }],
  Struct[{ 'otlp' => Otelcol::Telemetry_exporter::Periodic }],
]
