# frozen_string_literal: true

require 'spec_helper'

describe 'Otelcol::Component::Name' do
  describe 'valid handling' do
    %w[
      foo01
      foo-10
      batch
      memory_limiter
      memory_limiter/1
      memory_limiter/foo
      123
      foo
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid handling' do
    context 'garbage inputs' do
      [
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
        'memory_limiter/',
        '/asd'
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
