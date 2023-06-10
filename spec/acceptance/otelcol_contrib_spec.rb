# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Otelcol class' do
  context 'otelcol-contib', 'init.pp' do
    # Using puppet_apply as a helper
    # it_behaves_like 'init', 'init.pp'
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'otelcol':
        manage_archive    => true,
        package_name      => 'otelcol-contrib',
        config_file_owner => 'otelcol-contrib',
        config_file_group => 'otelcol-contrib',
        metrics_address_port => 8889,
        receivers         => {
          'otlp'       => {
            'protocols' => {
              'grpc' => { 'endpoint' => 'localhost:4319' },
              'http' => { 'endpoint' => 'localhost:4320' },
            },
          },
          'prometheus' => {
            'config' => {
              'scrape_configs' => [
                {
                  'job_name'        => 'otel-collector',
                  'scrape_interval' => '10s',
                  'static_configs'  => [
                    { 'targets' => ['localhost:8889'] }
                  ],
                },
              ],
            },
          },
        },
        exporters         => { 'logging' => { 'verbosity' => 'detailed' } },
        pipelines         => {
          'metrics' => {
            'receivers' => ['otlp', 'prometheus'],
            'exporters' => ['logging'],
          },
        },
        processors        => { 'batch' => {} },
      }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('otelcol-contrib') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
