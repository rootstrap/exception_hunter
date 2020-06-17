require 'delayed_job'

module ExceptionHunter
  module Middleware
    class DelayedJobHunter < ::Delayed::Plugin
      TRACK_AT_RETRY = [0, 3, 6, 10].freeze
      JOB_TRACKED_DATA = %w[
        attempts
      ].freeze
      ARGS_TRACKED_DATA = %w[
        queue_name
        job_class
        job_id
        arguments
        enqueued_at
      ].freeze

      callbacks do |lifecycle|
        lifecycle.around(:invoke_job) do |job, *args, &block|
          block.call(job, *args)

        rescue Exception => exception # rubocop:disable Lint/RescueException
          track_exception(exception, job)

          raise exception
        end
      end

      def self.track_exception(exception, job)
        return unless should_track?(job.attempts)

        ErrorCreator.call(
          tag: ErrorCreator::WORKER_TAG,
          class_name: exception.class.to_s,
          message: exception.message,
          environment_data: environment_data(job),
          backtrace: exception.backtrace
        )
      end

      def self.environment_data(job)
        job_data =
          JOB_TRACKED_DATA.each_with_object({}) do |data_param, dict|
            dict[o] = job.send(data_param)
          end
        args_data = (job.payload_object.job_data || {}).select { |key, _value| ARGS_TRACKED_DATA.include?(key) }

        job_data.merge(args_data)
      end

      def self.should_track?(attempts)
        TRACK_AT_RETRY.include?(attempts)
      end
    end
  end
end

Delayed::Worker.plugins << ExceptionHunter::Middleware::DelayedJobHunter
