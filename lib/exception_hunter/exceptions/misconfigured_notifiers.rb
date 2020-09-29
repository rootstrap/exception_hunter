module ExceptionHunter
  module Exceptions
    class MisconfiguredNotifiers < StandardError
      def initialize(notifier)
        super("Notifier has incorrect configuration: #{notifier.inspect}")
      end
    end
  end
end
