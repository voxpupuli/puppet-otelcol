# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::connector' do
  let(:title) { 'count' }
  let(:params) do
    {
      'config' => {
        'key' => 'value',
      },
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_concat__fragment('otelcol-config-connectors-count').with({
                                                                                          'order' => 1500,
                                                                                          'target' => 'otelcol-config',
                                                                                        })
      }

      context 'with exporter and receiver pipelines' do
        let :params do
          super().merge({
                          'exporter_pipelines' => ['traces'],
                          'receiver_pipelines' => ['metrics'],
                        })
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_concat__fragment('otelcol-config-connectors-count').with({
                                                                                            'order' => 1500,
                                                                                            'target' => 'otelcol-config',
                                                                                          })
        }

        it {
          is_expected.to contain_concat__fragment('otelcol-config-connector-count-exporter-traces').with({
                                                                                                           'order' => 1500,
                                                                                                           'target' => 'otelcol-config',
                                                                                                         })
        }

        it {
          is_expected.to contain_concat__fragment('otelcol-config-connector-count-receiver-metrics').with({
                                                                                                            'order' => 1500,
                                                                                                            'target' => 'otelcol-config',
                                                                                                          })
        }
      end

      context 'with order' do
        let :params do
          super().merge({ 'order' => 1 })
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_concat__fragment('otelcol-config-connectors-count').with({
                                                                                            'order' => 1501,
                                                                                            'target' => 'otelcol-config',
                                                                                          })
        }
      end
    end
  end
end
