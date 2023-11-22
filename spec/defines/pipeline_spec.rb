# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::pipeline' do
  let(:title) { 'mypipeline' }
  let(:params) do
    {
      'config' => {},
    }
  end

  let(:configcontent) do
    {
      'service' => {
        'pipelines' => {
          'mypipeline' => {},
        },
      },
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('otelcol-config-pipeline-mypipeline').with({
          'order' => 5000,
          'target' => 'otelcol-config',
          'content' => configcontent.to_yaml,
        })
      }


      context 'with order' do
        let :params do
          super().merge({'order' => 1})
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat__fragment('otelcol-config-pipeline-mypipeline').with({
            'order' => 5001,
            'target' => 'otelcol-config',
            'content' => configcontent.to_yaml,
          })
        }
      end
    end
  end
end
