module ExceptionHunter
  module Notifiers
    # Error raised when there's a malformed notifier.
    class MisconfiguredNotifiers < StandardError
      def initialize(notifier)
        super("Notifier has incorrect configuration: #{notifier.inspect}")
      end
    end
  end
end
