# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'default include' do
        it { is_expected.to compile.with_all_deps }

        case facts[:os]['family']
        when 'windows'
          let(:configpath) { 'C:/Program Files/OpenTelemetry Collector/config.yaml' }
          let(:configowner) { 'NT AUTHORITY\SYSTEM' }
          let(:configgroup) { 'Administrators' }
          let(:configfilemode) { '0770' }
          let(:package_name) { 'OpenTelemetry Collector (0.135.0) - otelcol distribution' }
        else
          let(:configpath) { '/etc/otelcol/config.yaml' }
          let(:configowner) { 'otel' }
          let(:configgroup) { 'otel' }
          let(:configfilemode) { '0600' }
          let(:package_name) { 'otelcol' }
        end
        it {
          is_expected.to contain_class('otelcol::config')
          is_expected.to contain_concat('otelcol-config').with({
                                                                 'path' => configpath,
                                                                 'format' => 'yaml',
                                                                 'mode' => configfilemode,
                                                                 'owner' => configowner,
                                                                 'group' => configgroup,
                                                               })
          is_expected.to contain_concat__fragment('otelcol-config-header')
          is_expected.to contain_concat__fragment('otelcol-config-baseconfig')
        }

        unless facts[:os]['family'] == 'windows'
          it {
            is_expected.to contain_file('otelcol-environment').with_path('/etc/otelcol/otelcol.conf')
            is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol/config.yaml"})
            is_expected.to contain_file('otelcol-environment').without_content(%r{HTTPS?_PROXY})
          }
        end

        it {
          is_expected.to contain_class('otelcol::install')
          is_expected.to contain_package('otelcol').with_ensure('installed')
          is_expected.to contain_package('otelcol').with_name(package_name)
        }

        it {
          is_expected.to contain_class('otelcol::service')
          is_expected.to contain_service('otelcol').with_ensure('running').with_name('otelcol')
          is_expected.to contain_service('otelcol').with_enable('true').with_name('otelcol')
        }
      end

      context 'with package_name to otelcol-contrib' do
        let :params do
          {
            package_name: 'otelcol-contrib',
          }
        end

        case facts[:os]['family']
        when 'windows'
          let(:configpath) { 'C:/Program Files/OpenTelemetry Collector/config.yaml' }
          let(:configowner) { 'NT AUTHORITY\SYSTEM' }
          let(:configgroup) { 'Administrators' }
          let(:configfilemode) { '0770' }
          let(:package_name) { 'OpenTelemetry Collector (0.135.0) - otelcol-contrib distribution' }
        else
          let(:configpath) { '/etc/otelcol-contrib/config.yaml' }
          let(:configowner) { 'otelcol-contrib' }
          let(:configgroup) { 'otelcol-contrib' }
          let(:configfilemode) { '0600' }
          let(:package_name) { 'otelcol-contrib' }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_class('otelcol::config')
          is_expected.to contain_concat('otelcol-config').with_path(configpath)
          # is_expected.to contain_file('otelcol-config').with_content(%r{"otlp":\s\{\s"protocols":\s\{\s"http":})
        }

        unless facts[:os]['family'] == 'windows'
          it {
            is_expected.to contain_file('otelcol-environment').with_path('/etc/otelcol-contrib/otelcol-contrib.conf')
            is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol-contrib/config.yaml"})
          }
        end

        it { # Validate YAML for config
          is_expected.to contain_concat('otelcol-config').with({
                                                                 'path' => configpath,
                                                                 'format' => 'yaml',
                                                                 'mode' => configfilemode,
                                                                 'owner' => configowner,
                                                                 'group' => configgroup,
                                                               })
          # .with_content(configcontent.to_yaml)
          # yaml_object = YAML.load(catalogue.resource('file', 'otelcol-config').send(:parameters)[:content])
          # expect(yaml_object.length).to be > 0
        }

        it {
          is_expected.to contain_class('otelcol::install')
          is_expected.to contain_package('otelcol').with_ensure('installed')
          is_expected.to contain_package('otelcol').with_name(package_name)
          is_expected.to contain_service('otelcol').with_name('otelcol-contrib')
        }

        context 'with manage archive' do
          let :params do
            {
              package_name: 'otelcol-contrib',
              manage_archive: true,
            }
          end

          let(:package_source) do
            case facts[:os]['family']
            when 'Debian'
              'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol-contrib_0.135.0_linux_amd64.deb'
            when 'RedHat'
              'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol-contrib_0.135.0_linux_amd64.rpm'
            when 'windows'
              'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol-contrib_0.135.0_windows_x64.msi'
            end
          end
          let(:package_localpath) do
            case facts[:os]['family']
            when 'windows'
              "C:/Windows/Temp/#{package_source.split('/').last}"
            else
              "/tmp/#{package_source.split('/').last}"
            end
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('otelcol_package').with_source(package_source.to_s) }
          it { is_expected.to contain_package('otelcol').with_source(package_localpath.to_s) }
        end
      end

      # Windows does not support latest
      unless facts[:os]['family'] == 'windows'
        context 'with package_ensure' do
          let :params do
            {
              package_ensure: 'latest',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package('otelcol').with_ensure('latest') }
        end
      end

      unless facts[:os]['family'] == 'windows'
        context 'with environment_file' do
          let :params do
            {
              environment_file: '/etc/otelcol/env.conf',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('otelcol-environment').with_path('/etc/otelcol/env.conf') }
        end

        context 'with run_options' do
          let :params do
            {
              run_options: '--debug',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('otelcol-environment').with_content(%r{--debug}) }
        end
      end
      unless facts[:os]['family'] == 'windows'
        context 'with config_file' do
          let :params do
            {
              config_file: '/etc/otelcol/test.conf',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it {
            is_expected.to contain_concat('otelcol-config').with_path('/etc/otelcol/test.conf')
            is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol/test.conf"})
          }
        end

        context 'with configs' do
          let :params do
            {
              configs: ['customconfig.yaml', 'env:MY_CONFIG_IN_AN_ENVVAR', 'https://server/config.yaml', '"yaml:exporters::debug::verbosity: normal"']
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol/config.yaml --config=customconfig.yaml --config=env:MY_CONFIG_IN_AN_ENVVAR --config=https://server/config.yaml --config="yaml:exporters::debug::verbosity: normal"}) }
        end
      end

      context 'with config_file owner' do
        let :params do
          {
            config_file_owner: 'root',
            config_file_group: 'root',
            config_file_mode: '0640',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_concat('otelcol-config').with(
            'owner' => 'root',
            'group' => 'root',
            'mode'  => '0640'
          )
        }
      end

      context 'with receivers' do
        let :params do
          {
            receivers: {
              'test' => {},
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_otelcol__receiver('test').with({
                                                                  'config' => {},
                                                                  'pipelines' => [],
                                                                  'order' => 0,
                                                                  'name' => 'test',
                                                                })
          is_expected.to contain_otelcol__component('test-receivers')
          is_expected.to contain_concat__fragment('otelcol-config-receivers-test')
        }
      end

      context 'with processors' do
        let :params do
          {
            processors: {
              'test' => {},
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_otelcol__processor('test').with({
                                                                   'config' => {},
                                                                   'pipelines' => [],
                                                                   'order' => 10,
                                                                   'name' => 'test',
                                                                 })
          is_expected.to contain_otelcol__component('test-processors')
          is_expected.to contain_concat__fragment('otelcol-config-processors-test')
        }
      end

      context 'with exporters' do
        let :params do
          {
            exporters: {
              'test' => {},
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_otelcol__exporter('test').with({
                                                                  'config' => {},
                                                                  'pipelines' => [],
                                                                  'order' => 0,
                                                                  'name' => 'test',
                                                                })
          is_expected.to contain_otelcol__component('test-exporter')
          is_expected.to contain_concat__fragment('otelcol-config-exporters-test')
        }
      end

      context 'with pipelines' do
        let :params do
          {
            pipelines: {
              'test' => {},
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_otelcol__pipeline('test').with({
                                                                  'config' => {},
                                                                  'order' => 0,
                                                                  'name' => 'test',
                                                                })
          is_expected.to contain_concat__fragment('otelcol-config-pipeline-test')
        }
      end

      context 'with extensions' do
        let :params do
          {
            extensions: {
              'test' => {},
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_otelcol__extension('test').with({
                                                                   'config' => {},
                                                                   'order' => 0,
                                                                   'name' => 'test',
                                                                 })
          is_expected.to contain_concat__fragment('otelcol-config-extension-test')
        }
      end

      context 'with logoptions' do
        let :params do
          {
            log_options: {
              'level' => 'debug',
            },
          }
        end
        let(:configcontent) do
          {
            'service' => {
              'telemetry' => {
                'logs' => {
                  'level' => 'debug'
                },
                'metrics' => {
                  'level' => 'basic',
                  'readers' => [
                    { 'pull' => { 'exporter' => { 'prometheus' => { 'host' => '0.0.0.0', 'port' => 8888 } } } },
                  ],
                },
              },
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat__fragment('otelcol-config-baseconfig').with_content(configcontent.to_yaml) }
      end

      context 'with metrics config' do
        let :params do
          {
            metrics_level: 'detailed',
          }
        end
        let(:configcontent) do
          {
            'service' => {
              'telemetry' => {
                'logs' => {},
                'metrics' => {
                  'level' => 'detailed',
                  'readers' => [
                    { 'pull' => { 'exporter' => { 'prometheus' => { 'host' => '0.0.0.0', 'port' => 8888 } } } },
                  ],
                },
              },
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat__fragment('otelcol-config-baseconfig').with_content(configcontent.to_yaml) }
      end

      context 'with multiple telemetry config' do
        let :params do
          {
            telemetry_exporters: [
              { 'prometheus' => { 'host' => '0.0.0.0', 'port' => 8888 } },
              { 'otlp' => { 'endpoint' => 'https://example.org', 'protocol' => 'http/protobuf' } }
            ],
          }
        end
        let(:configcontent) do
          {
            'service' => {
              'telemetry' => {
                'logs' => {},
                'metrics' => {
                  'level' => 'basic',
                  'readers' => [
                    { 'pull' => { 'exporter' => { 'prometheus' => { 'host' => '0.0.0.0', 'port' => 8888 } } } },
                    { 'periodic' => { 'exporter' => { 'otlp' => { 'endpoint' => 'https://example.org', 'protocol' => 'http/protobuf' } } } },
                  ],
                },
              },
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat__fragment('otelcol-config-baseconfig').with_content(configcontent.to_yaml) }
      end

      context 'with service_ensure' do
        let :params do
          {
            service_ensure: 'stopped',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_service('otelcol').with_ensure('stopped') }
      end

      unless facts[:os]['family'] == 'windows'
        context 'with proxy_host' do
          let :params do
            {
              proxy_host: '127.0.0.1',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('otelcol-environment').with_content(%r{HTTP_PROXY="127.0.0.1:8888"}) }
          it { is_expected.to contain_file('otelcol-environment').with_content(%r{HTTPS_PROXY="127.0.0.1:8888"}) }
        end
      end

      context 'with service_configcheck' do
        let :params do
          {
            service_configcheck: true,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_service('otelcol').that_requires('Exec[otelcol_config_check]') }

        case facts[:os]['family']
        when 'windows'
          let(:binary_path) { 'otelcol.exe' }
          let(:config_path) { 'C:/Program Files/OpenTelemetry Collector/config.yaml' }
        else
          let(:binary_path) { 'otelcol' }
          let(:config_path) { '/etc/otelcol/config.yaml' }
        end

        it {
          is_expected.to contain_exec('otelcol_config_check').with(
            'command'     => "#{binary_path} validate --config=\"#{config_path}\"",
            'refreshonly' => true,
            'path'        => [
              '/usr/local/sbin',
              '/usr/local/bin',
              '/usr/sbin',
              '/usr/bin',
              '/sbin',
              '/bin',
              '%PROGRAMFILES%\OpenTelemetry Collector',
              'C:/Program Files/OpenTelemetry Collector',
            ]
          )
        }
      end

      context 'with service_configcheck disabled' do
        let :params do
          {
            service_configcheck: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_exec('otelcol_config_check') }
        it { is_expected.to contain_service('otelcol').that_requires('Package[otelcol]') }
      end

      context 'do not manage Service' do
        let :params do
          {
            manage_service: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('otelcol::service') }
      end

      context 'manage archive' do
        let :params do
          {
            manage_archive: true,
          }
        end

        let(:package_source) do
          case facts[:os]['family']
          when 'Debian'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol_0.135.0_linux_amd64.deb'
          when 'RedHat'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol_0.135.0_linux_amd64.rpm'
          when 'windows'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol_0.135.0_windows_x64.msi'
          end
        end
        let(:package_localpath) do
          case facts[:os]['family']
          when 'windows'
            "C:/Windows/Temp/#{package_source.split('/').last}"
          else
            "/tmp/#{package_source.split('/').last}"
          end
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('otelcol_package').with_source(package_source.to_s) }
        it { is_expected.to contain_package('otelcol').with_source(package_localpath.to_s) }
      end

      context 'manage archive with Version' do
        let :params do
          {
            manage_archive: true,
            archive_version: '0.132.4'
          }
        end

        let(:package_source) do
          case facts[:os]['family']
          when 'Debian'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.132.4/otelcol_0.132.4_linux_amd64.deb'
          when 'RedHat'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.132.4/otelcol_0.132.4_linux_amd64.rpm'
          when 'windows'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.132.4/otelcol_0.132.4_windows_x64.msi'
          end
        end
        let(:package_localpath) do
          case facts[:os]['family']
          when 'windows'
            "C:/Windows/Temp/#{package_source.split('/').last}"
          else
            "/tmp/#{package_source.split('/').last}"
          end
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('otelcol_package').with_source(package_source.to_s) }
        it { is_expected.to contain_package('otelcol').with_source(package_localpath.to_s) }
      end
    end
  end
end
