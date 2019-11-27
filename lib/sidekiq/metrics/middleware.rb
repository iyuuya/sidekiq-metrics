# frozen_string_literal: true

module Sidekiq
  module Metrics
    class Middleware
      attr_accessor :msg

      def call(worker, msg, queue)
        worker_status = { last_job_status: 'passed' }
        start = Time.now
        yield
      rescue => e
        worker_status[:last_job_status] = 'faield'
        raise e
      ensure
        finish = Time.now
        # worker_status[:queue]= msg['queue']
        worker_status[:started_at] = start.utc.to_i
        worker_status[:finished_at] = finish.utc.to_i
        worker_status[:class] = msg['wrapped'] || worker.class.to_s
        if worker_status[:class] == 'ActionMailer::DeliveryJob'
          worker_status[:class] = msg['args'].first['arguments'].first
        end

        worker_status[:worker] = worker
        worker_status[:msg] = msg
        worker_status[:queue] = queue

        save_entry_for_worker(worker_status)
      end

      private

      def save_entry_for_worker(worker_status)
        Sidekiq::Metrics.configuration.adapter.write(worker_status)
      end
    end
  end
end
