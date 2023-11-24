# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Otelcol class' do
  it_behaves_like 'the example', 'basic_installation.pp' do
    describe service('otelcol') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe port(8888) do
      it { should be_listening }
    end
  end
end
