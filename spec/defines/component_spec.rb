# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::component' do
  let(:title) { 'otlp-receivers' }
  let(:params) do
    {
      'config' => {
        'key' => 'value',
      },
      'type'  => 'receivers',
      'component_name' => 'otlp'
    }
  end

  let(:configcontent) do
    {
      'receivers' => {
        'otlp' => {
          'key' => 'value',
        },
      },
    }
  end


  let(:configcontentpipeline) do
    {
      'service' => {
        'pipelines' => {
          'test' => {
            'receivers' => ['otlp'],
          }
        },
      },
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp') }
      it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp').with_content(configcontent.to_yaml) }
      it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp').with_order(0) }

      # Create Checks for importer with extended parameters with order
      context 'with order' do
        let :params do
          super().merge({'order' => 1})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp').with_order(1) }
      end

      # Create Check for importer with extended parameters with pipelines array
      context 'with pipelines array' do
        let :params do
          super().merge({'pipelines' => ['test']})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test') }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test').with_content(configcontentpipeline.to_yaml) }
      end

      # Create Check for importer with extended parameters with pipelines array
      context 'with pipelines array' do
        let(:params) do
          super().merge({'pipelines' => ['test', 'test2']})
        end

        let(:configcontentpipeline2) do
          {
            'service' => {
              'pipelines' => {
                'test2' => {
                  'receivers' => ['otlp'],
                }
              },
            },
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test') }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test').with_content(configcontentpipeline.to_yaml) }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test2') }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test2').with_content(configcontentpipeline2.to_yaml) }
      end

      # Create Check for importer with extended parameters with pipelines array and order
      context 'with pipelines array and order' do
        let(:params) do
          super().merge({'pipelines' => ['test'], 'order' => 1})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test') }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test').with_content(configcontentpipeline.to_yaml) }
        it { is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp-test').with_order(1) }
      end
    end
  end
end
