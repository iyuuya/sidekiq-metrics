# frozen_string_literal: true

require 'spec_helper'
require 'stringio'
require 'logger'
require 'pry'

class TestWorker
  include Sidekiq::Worker
end

class TestWithQueueWorker
  include Sidekiq::Worker
  sidekiq_options queue: :test
end

RSpec.describe Sidekiq::Metrics::Middleware do
  def middlewared(worker_class = TestWorker, msg = {})
    middleware = Sidekiq::Metrics::Middleware.new
    middleware.call worker_class.new, msg, 'default' do
      yield
    end
  end

  def parsed_logs
    # NOTE: order by writed at descending
    @parse_logs ||= io.string&.lines&.map(&:chop)&.map { |line| JSON.parse(line&.match(/({.+})/)[1]) }
  end

  let(:io) { StringIO.new }
  let(:logger) { Logger.new(io) }

  before do
    Sidekiq::Metrics.configure do |config|
      config.adapter = Sidekiq::Metrics::Adapter::Logger.new(logger)
    end
  end

  describe '#call(worker, msg, queue)' do
    it 'records metrics for passwed worker' do
      middlewared {}
      expect(parsed_logs[0]['status']).to eq 'passed'
    end

    it 'records metrics for failed worker' do
      begin
        middlewared do
          raise StandardError.new('failed')
        end
      rescue
      end

      expect(parsed_logs[0]['status']).to eq 'failed'
    end

    it 'records metrics for any workers' do
      middlewared {}
      begin
        middlewared do
          raise StandardError.new('failed')
        end
      rescue
      end
      middlewared {}

      expect(parsed_logs[0]['status']).to eq 'passed'
      expect(parsed_logs[1]['status']).to eq 'failed'
      expect(parsed_logs[2]['status']).to eq 'passed'
    end

    it 'support multithread calculations' do
      workers = []
      20.times do
        workers << Thread.new do
          25.times { middlewared {} }
        end
      end

      workers.each(&:join)

      expect(parsed_logs.count).to eq 500
    end

    it 'records retry' do
      middlewared(TestWorker, { 'retry' => true }) {}
      middlewared(TestWorker, { 'retry' => false }) {}
      middlewared(TestWorker) {}

      expect(parsed_logs[0]['retry']).to eq true
      expect(parsed_logs[1]['retry']).to eq false
      expect(parsed_logs[2]['retry']).to eq false
    end

    it 'records class' do
      middlewared(TestWorker) {}
      middlewared(TestWithQueueWorker) {}

      expect(parsed_logs[0]['class']).to eq 'TestWorker'
      expect(parsed_logs[1]['class']).to eq 'TestWithQueueWorker'
    end

    it 'records queue' do
      middlewared(TestWorker, { 'queue' => 'default' }) {}
      middlewared(TestWithQueueWorker, { 'queue' => 'test' }) {}

      expect(parsed_logs[0]['queue']).to eq 'default'
      expect(parsed_logs[1]['queue']).to eq 'test'
    end

    it 'records queue' do
      jid = SecureRandom.hex(12)
      middlewared(TestWorker, { 'jid' => jid }) {}

      expect(parsed_logs[0]['jid']).to eq jid
    end

    it 'records enqueud_at' do
      enqueued_at = Time.now.to_f
      middlewared(TestWorker, { 'enqueued_at' => enqueued_at }) {}
      expect(parsed_logs[0]['enqueued_at']).to eq enqueued_at
    end

    it 'records started_at' do
      start = Time.now
      allow(Time).to receive(:now).and_return(start)
      middlewared {}
      expect(parsed_logs[0]['started_at']).to eq start.to_f
    end

    it 'records finished_at' do
      finish = Time.now
      allow(Time).to receive(:now).and_return(finish)
      middlewared {}
      expect(parsed_logs[0]['finished_at']).to eq finish.to_f
    end

    it 'not records other messages' do
      middlewared(TestWorker, { 'args' => [1, 2, 3], 'created_at' => Time.now.to_f }) {}

      expect(parsed_logs[0]).to_not have_key 'args'
      expect(parsed_logs[0]).to_not have_key 'created_at'
    end

    context 'when worker includes in exclude list' do
      it 'not records all meessages' do
        allow(Sidekiq::Metrics.configuration).to receive(:excludes).and_return(Set.new(['TestWorker']))
        middlewared(TestWorker, { 'queue' => 'excluded!!' }) {}
        middlewared(TestWithQueueWorker, { 'queue' => 'not exlcuded!!' }) {}

        expect(parsed_logs.count).to eq 1
        expect(parsed_logs[0]['class']).to eq 'TestWithQueueWorker'
      end
    end
  end
end
