# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::Metrics::Adapter::Logger do
  describe '.new(logger)' do
    context 'default' do
      subject { described_class.new }

      it { expect(subject.logger).to eq Sidekiq.logger }
    end
  end

  describe '#write(worker_status)' do
    let(:adapter) { described_class.new }
    let(:worker_status) { { foo: 'bar' } }

    it { expect(Sidekiq.logger).to receive(:info).with(worker_status.to_json); adapter.write(worker_status) }
  end
end
