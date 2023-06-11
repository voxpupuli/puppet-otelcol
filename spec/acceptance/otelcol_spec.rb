# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Otelcol class' do
  context 'minimal parameters', 'init.pp' do
    # Using puppet_apply as a helper
    # it_behaves_like 'init', 'init.pp'

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'otelcol':
          manage_archive => true,
          receivers      => {
            'otlp'       => {
              'protocols' => {
                'grpc' => { 'endpoint' => 'localhost:4317' },
                'http' => { 'endpoint' => 'localhost:4318' },
              },
            },
            'prometheus' => {
              'config' => {
                'scrape_configs' => [
                  {
                    'job_name'        => 'otel-collector',
                    'scrape_interval' => '10s',
                    'static_configs'  => [
                      { 'targets' => ['localhost:8888'] }
                    ],
                  },
                ],
              },
            },
          },
          exporters      => { 'logging' => { 'verbosity' => 'detailed' } },
          pipelines      => {
            'metrics' => {
              'receivers' => ['otlp', 'prometheus'],
              'exporters' => ['logging'],
            },
          },
          processors     => { 'batch' => {} },
        }
        PUPPET
      end
    end

    describe service('otelcol') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
