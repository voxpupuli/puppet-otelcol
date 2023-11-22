# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::exporter' do
  let(:title) { 'otlp' }
  let(:params) do
    {
      'config' => {
        'key' => 'value',
      }
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_otelcol__component('otlp-exporter').with({
        'order' => 3000,
        'config' => {
          'key' => 'value',
        },
        'pipelines' => [],
        'type' => 'exporters',
        'component_name' => 'otlp',
      }) }
      it {
        is_expected.to contain_concat__fragment('otelcol-config-exporters-otlp').with({
          'order' => 3000,
          'target' => 'otelcol-config',
        })
      }


      context 'with order' do
        let :params do
          super().merge({'order' => 1})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_otelcol__component('otlp-exporter').with({
          'order' => 3001,
          'config' => {
            'key' => 'value',
          },
          'pipelines' => [],
          'type' => 'exporters',
          'component_name' => 'otlp',
        }) }
      end

    end
  end
end
