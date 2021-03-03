module ExceptionHunter
  class AsyncLoggingJob < ApplicationJob
    queue_as :default

    def perform(tag, error_attrs)
      ErrorCreator.call(async_logging: false, tag: tag, **error_attrs)
    rescue Exception # rubocop:disable Lint/RescueException
      # Suppress all exceptions to avoid loop as this would create a new error in EH.
      false
    end
  end
end
