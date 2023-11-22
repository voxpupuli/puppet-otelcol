# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::receiver' do
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
      it { is_expected.to contain_otelcol__component('otlp-receivers').with({
        'order' => 1000,
        'config' => {
          'key' => 'value',
        },
        'pipelines' => [],
        'type' => 'receivers',
        'component_name' => 'otlp',
      }) }
      it {
        is_expected.to contain_concat__fragment('otelcol-config-receivers-otlp').with({
          'order' => 1000,
          'target' => 'otelcol-config',
        })
      }


      context 'with order' do
        let :params do
          super().merge({'order' => 1})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_otelcol__component('otlp-receivers').with({
          'order' => 1001,
          'config' => {
            'key' => 'value',
          },
          'pipelines' => [],
          'type' => 'receivers',
          'component_name' => 'otlp',
        }) }
      end

    end
  end
end
