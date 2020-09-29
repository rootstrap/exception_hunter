module ExceptionHunter
  class SendNotificationJob < ApplicationJob
    queue_as :default

    def perform(serialized_notifier)
      # Use SlackNotifierSerializer as it's the only one for now.
      deserialized_notifier = ExceptionHunter::Serializers::SlackNotifierSerializer.deserialize(serialized_notifier)
      deserialized_notifier.notify
    rescue Exception # rubocop:disable Lint/RescueException
      # Suppress all exceptions to avoid loop as this would create a new error in EH.
      false
    end
  end
end
