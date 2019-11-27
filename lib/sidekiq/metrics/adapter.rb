# frozen_string_literal: true

require 'sidekiq/metrics/adapter/base'

module Sidekiq
  module Metrics
    module Adapter
      autoload :Logger, 'sidekiq/metrics/adapter/logger'
    end
  end
end
