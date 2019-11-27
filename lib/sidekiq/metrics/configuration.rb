# frozen_string_literal: true

module Sidekiq
  module Metrics
    class Configuration
      attr_accessor :adapter

      def initialize
        @adapter = ::Sidekiq::Metrics::Adapter::Logger.new
      end
    end
  end
end
