# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol' do
  let(:pre_condition) do
    <<-PUPPET
      otelcol::receiver { 'foo':
        config    => {},
        pipelines => ['traces'],
      }

      otelcol::exporter { 'bar':
        config    => {},
        pipelines => ['metrics'],
      }

      otelcol::connector { 'count':
        config             => {},
        exporter_pipelines => ['traces'],
        receiver_pipelines => ['metrics'],
      }
    PUPPET
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os} with connector pipeline" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'manage_archive' => false,
        }
      end

      it { is_expected.to compile.with_all_deps }

      # Verify connector is defined in connectors section
      it {
        is_expected.to contain_concat__fragment('otelcol-config-connectors-count')
      }

      # Verify connector is used as exporter in traces pipeline
      it {
        is_expected.to contain_concat__fragment('otelcol-config-connector-count-exporter-traces')
      }

      # Verify connector is used as receiver in metrics pipeline
      it {
        is_expected.to contain_concat__fragment('otelcol-config-connector-count-receiver-metrics')
      }

      # Verify receiver is in traces pipeline
      it {
        is_expected.to contain_concat__fragment('otelcol-config-receivers-foo-traces')
      }

      # Verify exporter is in metrics pipeline
      it {
        is_expected.to contain_concat__fragment('otelcol-config-exporters-bar-metrics')
      }
    end
  end
end
