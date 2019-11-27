# frozen_string_literal: true

module Sidekiq
  module Metrics
    module Adapter
      class Base
        def write
          raise NotImplementedError, 'Subclasses must define `write`.'
        end
      end
    end
  end
end
