# frozen_string_literal: true

require 'json'

module Sidekiq
  module Metrics
    module Adapter
      class Logger < Base
        attr_accessor :logger

        def initialize(logger = Sidekiq.logger)
          @logger = logger
        end

        def write(worker_status)
          logger.info worker_status.to_json
        end
      end
    end
  end
end
