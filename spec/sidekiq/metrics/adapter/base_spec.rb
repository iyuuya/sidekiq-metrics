# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::Metrics::Adapter::Base do
  describe '#write(worker_status)' do
    it { expect { described_class.new.write({}) }.to raise_error NotImplementedError, 'Subclasses must define `write`.' }
  end
end
