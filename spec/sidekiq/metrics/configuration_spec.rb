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

  describe '#excludes' do
    subject { described_class.new.excludes }

    it 'default value is a Set instance' do
      is_expected.to be_a Set
      is_expected.to be_empty
    end

    it 'can add value' do
      expect { subject << 'HelloWorker' }.to change { subject.count }.by(1)
    end
  end

  describe 'not #excludes=(v)' do
    it 'can not set value' do
      expect { configuration.excludes = [] }.to raise_error
    end
  end
end
