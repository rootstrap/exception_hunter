module ExceptionHunter
  module Notifiers
    module Serializers
      class SlackNotifierSerializer
        def self.serialize(slack_notifier)
          {
            error: slack_notifier.error,
            notifier: slack_notifier.notifier.as_json
          }
        end

        def self.deserialize(hash)
          ExceptionHunter::Notifiers::SlackNotifier.new(
            hash[:error],
            hash[:notifier].deep_symbolize_keys
          )
        end
      end
    end
  end
end
