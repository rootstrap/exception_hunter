module ExceptionHunter
  module Middleware
    # Middleware to report errors
    # when a Sidekiq worker fails
    class SidekiqHunter
      TRACK_AT_RETRY = [0, 3, 6, 10].freeze
      JOB_TRACKED_DATA = %w[
        queue
        retry_count
      ].freeze
      ARGS_TRACKED_DATA = %w[
        job_class
        job_id
        arguments
        enqueued_at
      ].freeze

      def call(_worker, context, _queue)
        yield
      rescue Exception => exception # rubocop:disable Lint/RescueException
        track_exception(exception, context)
        raise exception
      end

      private

      def track_exception(exception, context)
        return unless should_track?(context)

        ErrorCreator.call(
          async_logging: false,
          tag: ErrorCreator::WORKER_TAG,
          class_name: exception.class.to_s,
          message: exception.message,
          environment_data: environment_data(context),
          backtrace: exception.backtrace
        )
      end

      def environment_data(context)
        job_data = context.select { |key, _value| JOB_TRACKED_DATA.include?(key) }
        args_data = (context['args']&.first || {}).select { |key, _value| ARGS_TRACKED_DATA.include?(key) }

        job_data.merge(args_data)
      end

      def should_track?(context)
        TRACK_AT_RETRY.include?(context['retry_count'].to_i)
      end
    end
  end
end

# As seen in https://github.com/mperham/sidekiq/wiki/Error-Handling
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add(ExceptionHunter::Middleware::SidekiqHunter)
  end
end
