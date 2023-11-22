# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::extension' do
  let(:title) { 'health_check' }
  let(:params) do
    {
      'config' => {},
    }
  end

  let(:configcontent) do
    {
    'extensions' => {
      'health_check' => {},
    },
    'service' => {
      'extensions' => ['health_check'],
    },
  }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('otelcol-config-extension-health_check').with({
          'order' => 4000,
          'target' => 'otelcol-config',
          'content' => configcontent.to_yaml,
        })
      }


      context 'with order' do
        let :params do
          super().merge({'order' => 1})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat__fragment('otelcol-config-extension-health_check').with({
            'order' => 4001,
            'target' => 'otelcol-config',
            'content' => configcontent.to_yaml,
          })
        }
      end
    end
  end
end
