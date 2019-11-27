# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::Metrics do
  describe '#configuration' do
    subject { described_class.configuration }
    it { is_expected.to be_a Sidekiq::Metrics::Configuration }
  end

  describe '#configure' do
    it 'configure metrics in block' do
      expect {
        Sidekiq::Metrics.configure { |config| config.adapter = :hello }
      }.to change{ Sidekiq::Metrics.configuration.adapter }.to(:hello)
    end
  end
end
