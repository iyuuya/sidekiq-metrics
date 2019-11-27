# frozen_string_literal: true

module Sidekiq
  module Metrics
    class Configuration
      attr_accessor :adapter
      attr_reader :excludes

      def initialize
        @adapter = ::Sidekiq::Metrics::Adapter::Logger.new
        @excludes = Set.new
      end
    end
  end
end
