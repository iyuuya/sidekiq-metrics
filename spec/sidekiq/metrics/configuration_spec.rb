# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::Metrics::Configuration do
  describe '#adapter' do
    subject { described_class.new.adapter }

    it 'default value is a ::Sidekiq::Metrics::Adapter::Logger instance' do
      is_expected.to be_a ::Sidekiq::Metrics::Adapter::Logger
    end
  end

  describe '#adapter=(v)' do
    let(:configuration) { described_class.new }

    it 'can set value' do
      expect { configuration.adapter = :foo }.to change { configuration.adapter }.to(:foo)
    end
  end
end
