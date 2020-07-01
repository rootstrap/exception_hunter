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
            dict.merge(data_param => job.try(data_param))
          end

        job_class = if job.payload_object.class.name == 'ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper'
                      #buildin support for Rails 4.2 ActiveJob
                      job.payload_object.job_data['job_class']
                    elsif job.payload_object.object.is_a?(Class)
                      job.payload_object.object.name
                    else
                      job.payload_object.object.class.name
                    end
        args_data = (job.payload_object.try(:job_data) || {}).select { |key, _value| ARGS_TRACKED_DATA.include?(key) }

        args_data['job_class'] = job_class || job.payload_object.class.name if args_data['job_class'].nil?

        job_data.merge(args_data)
      end

      def self.should_track?(attempts)
        TRACK_AT_RETRY.include?(attempts)
      end
    end
  end
end

Delayed::Worker.plugins << ExceptionHunter::Middleware::DelayedJobHunter
