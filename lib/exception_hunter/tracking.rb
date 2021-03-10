module ExceptionHunter
  # Mixin used to track manual exceptions.
  module Tracking
    # Used to manually track errors in cases where raising might
    # not be adequate and but some insight is desired.
    #
    # @example Track the else clause on a case
    #   case user.status
    #   when :active then do_something()
    #   when :inactive then do_something_else()
    #   else
    #     ExceptionHunter.track(StandardError.new("User with unknown status"),
    #                                             custom_data: { status: user.status },
    #                                             user: user)
    #   end
    #
    # @param [Exception] exception to track.
    # @param [Hash] custom_data to include and help debug the error. (optional)
    # @param [User] user in the current session. (optional)
    # @return [void]
    def track(exception, custom_data: {}, user: nil)
      open_transactions? ? create_error_within_new_thread(exception, custom_data, user) : create_error(exception, custom_data, user)

      nil
    end

    private

    def create_error_within_new_thread(exception, custom_data, user)
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          create_error(exception, custom_data, user)
        end
      end
    end

    def create_error(exception, custom_data, user)
      ErrorCreator.call(
        tag: ErrorCreator::MANUAL_TAG,
        class_name: exception.class.to_s,
        message: exception.message,
        backtrace: exception.backtrace,
        custom_data: custom_data,
        user: user,
        environment_data: {}
      )
    end

    def open_transactions?
      ActiveRecord::Base.connection.open_transactions.positive?
    end
  end
end
