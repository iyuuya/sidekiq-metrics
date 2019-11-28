# frozen_string_literal: true

module Sidekiq
  module Metrics
    class Middleware
      def call(worker, msg, queue)
        if exclude?(worker.class)
          yield
        else
          with_collect_metrics(worker, msg, queue) do
            yield
          end
        end
      end

      private

      def with_collect_metrics(worker, msg, queue)
        worker_status = { status: 'passed' }
        start = Time.now
        yield
      rescue => e
        worker_status[:status] = 'failed'
        raise e
      ensure
        finish = Time.now
        worker_status[:retry] = !!msg['retry']
        worker_status[:queue]= msg['queue'] || queue
        worker_status[:class] = worker.class.to_s
        worker_status[:jid] = msg['jid']
        worker_status[:enqueued_at] = msg['enqueued_at']
        worker_status[:started_at] = start.to_f
        worker_status[:finished_at] = finish.to_f

        save_entry_for_worker(worker_status)
      end

      def save_entry_for_worker(worker_status)
        Sidekiq::Metrics.configuration.adapter.write(worker_status)
      end

      def exclude?(worker_class)
        Sidekiq::Metrics.configuration.excludes.include?(worker_class.to_s)
      end
    end
  end
end
