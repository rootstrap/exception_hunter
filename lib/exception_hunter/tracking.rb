module ExceptionHunter
  module Tracking
    def track(exception, custom_data: {}, user: nil)
      ErrorCreator.call(
        tag: ErrorCreator::MANUAL_TAG,
        class_name: exception.class.to_s,
        message: exception.message,
        backtrace: exception.backtrace,
        custom_data: custom_data,
        user: user
      )

      nil
    end
  end
end
