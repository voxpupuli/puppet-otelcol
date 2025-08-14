type Otelcol::Exporter = Hash[
  Enum['prometheus', 'otlp'],
  Variant[Otelcol::Exporter::Pull, Otelcol::Exporter::Periodic],
]
