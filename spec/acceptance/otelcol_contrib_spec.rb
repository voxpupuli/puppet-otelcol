# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Otelcol class with contrib' do
  it_behaves_like 'the example', 'contrib_installation.pp' do
    describe service('otelcol-contrib') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(8889) do
      it { is_expected.to be_listening }
    end
  end
end
