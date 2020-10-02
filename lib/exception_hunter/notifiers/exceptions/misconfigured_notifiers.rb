module ExceptionHunter
  module Notifiers
    module Exceptions
      class MisconfiguredNotifiers < StandardError
        def initialize(notifier)
          super("Notifier has incorrect configuration: #{notifier.inspect}")
        end
      end
    end
  end
end
