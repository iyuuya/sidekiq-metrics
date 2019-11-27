# frozen_string_literal: true

require 'sidekiq'

require 'sidekiq/metrics/version'
require 'sidekiq/metrics/adapter'
require 'sidekiq/metrics/configuration'
require 'sidekiq/metrics/middleware'

module Sidekiq
  module Metrics
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end
