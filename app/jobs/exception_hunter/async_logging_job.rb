module ExceptionHunter
  class AsyncLoggingJob < ApplicationJob
    queue_as :default

    def perform(tag, error_attrs)
      error_attrs = error_attrs.merge(occurred_at: Time.at(error_attrs[:occurred_at])) if error_attrs[:occurred_at]
      ErrorCreator.call(async_logging: false, tag: tag, **error_attrs)
    rescue Exception
      # Suppress all exceptions to avoid loop as this would create a new error in EH.
      false
    end
  end
end
