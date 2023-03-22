# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:config_dir) do
        case facts[:osfamily]
        when 'windows'
          'C:/Program Files/otelcol'
        else
          '/etc/otelcol'
        end
      end
      let(:main_config) { "#{config_dir}/config.yaml" }

      context 'default include'
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('otelcol::config') }
      it { is_expected.to contain_class('otelcol::install') }
      it { is_expected.to contain_class('otelcol::params') }
      it { is_expected.to contain_class('otelcol::service') }

      it do
        is_expected.to contain_class('otelcol').with(
          ensure: '1.3.5-1',
          receivers: [{
            'cpu' => [{
              'percpu' => true,
              'totalcpu' => true,
              'fielddrop' => ['time_*']
            }],
            'disk' => [{
              'ignore_fs' => %w[tmpfs devtmpfs]
            }],
            'diskio' => [{}],
            'kernel' => [{}],
            'exec' => [
              {
                'commands' => ['who | wc -l']
              },
              {
                'commands' => ["cat /proc/uptime | awk '{print $1}'"]
              }
            ],
            'mem' => [{}],
            'net' => [{
              'interfaces' => ['eth0'],
              'drop' => ['net_icmp']
            }],
            'netstat' => [{}],
            'ping' => [{
              'urls' => ['10.10.10.1'],
              'count' => 1,
              'timeout' => 1.0
            }],
            'statsd' => [{
              'service_address' => ':8125',
              'delete_gauges' => false,
              'delete_counters' => false,
              'delete_sets' => false,
              'delete_timings' => true,
              'percentiles' => [90],
              'allowed_pending_messages' => 10_000,
              'convert_names' => true,
              'percentile_limit' => 1000,
              'udp_packet_size' => 1500
            }],
            'swap' => [{}],
            'system' => [{}]
          }],
          exporters: [{
            'influxdb' => [{
              'urls' => ['http://influxdb.example.com:8086'],
              'database' => 'otelcol',
              'username' => 'otelcol',
              'password' => 'otelcol'
            }]
          }],
          processors: [{
            'rename_processor' => {
              'plugin_type' => 'rename',
              'options' => [{
                'order' => 1,
                'namepass' => ['diskio'],
                'replace' => { 'tag' => 'foo', 'dest' => 'bar' }
              }]
            }
          }]
        )
      end
    end
  end
end
