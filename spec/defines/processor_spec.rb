# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::processor' do
  let(:title) { 'batch' }
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

      it {
        is_expected.to contain_otelcol__component('batch-processors').with({
                                                                             'order' => 2010,
                                                                             'config' => {
                                                                               'key' => 'value',
                                                                             },
                                                                             'pipelines' => [],
                                                                             'type' => 'processors',
                                                                             'component_name' => 'batch',
                                                                           })
      }

      it {
        is_expected.to contain_concat__fragment('otelcol-config-processors-batch').with({
                                                                                          'order' => 2010,
                                                                                          'target' => 'otelcol-config',
                                                                                        })
      }

      context 'with order' do
        let :params do
          super().merge({ 'order' => 1 })
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_otelcol__component('batch-processors').with({
                                                                               'order' => 2001,
                                                                               'config' => {
                                                                                 'key' => 'value',
                                                                               },
                                                                               'pipelines' => [],
                                                                               'type' => 'processors',
                                                                               'component_name' => 'batch',
                                                                             })
        }
      end
    end
  end
end
