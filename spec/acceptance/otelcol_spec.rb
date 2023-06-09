# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Otelcol class' do
  context 'minimal parameters', 'init.pp' do
    # Using puppet_apply as a helper
    # it_behaves_like 'init', 'init.pp'
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'otelcol':
      }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('otelcol') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'otelcol-contib', 'init.pp' do
    # Using puppet_apply as a helper
    # it_behaves_like 'init', 'init.pp'
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'otelcol':
        $package_name => 'otelcol-contrib'
      }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('otelcol-contrib') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
