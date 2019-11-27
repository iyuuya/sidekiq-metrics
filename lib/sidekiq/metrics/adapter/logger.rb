# frozen_string_literal: true

require 'json'

module Sidekiq
  module Metrics
    module Adapter
      class SidekiqLogger < Base
        attr_accessor :logger

        def initialize(logger = Sidekiq::Logging.logger)
          @logger = logger
        end

        def write(worker_status)
          logger.info worker_status.to_json
        end
      end
    end
  end
end
