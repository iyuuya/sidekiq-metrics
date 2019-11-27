# frozen_string_literal: true

module Sidekiq
  module Metrics
    class Middleware
      def call(worker, msg, queue)
        worker_status = { status: 'passed' }
        start = Time.now
        yield
      rescue => e
        worker_status[:status] = 'failed'
        raise e
      ensure
        finish = Time.now
        worker_status[:queue]= msg['queue'] || queue
        worker_status[:class] = worker.class.to_s
        worker_status[:jid] = msg['jid']
        worker_status[:enqueued_at] = msg['enqueued_at']
        worker_status[:started_at] = start.to_f
        worker_status[:finished_at] = finish.to_f

        save_entry_for_worker(worker_status)
      end

      private

      def save_entry_for_worker(worker_status)
        Sidekiq::Metrics.configuration.adapter.write(worker_status)
      end
    end
  end
end
