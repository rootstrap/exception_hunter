require 'slack-notifier'

module ExceptionHunter
  module Notifiers
    # Notifier that sends a message to a Slack channel every time an
    # exception is tracked.
    class SlackNotifier
      attr_reader :error, :notifier

      def initialize(error, notifier)
        @error = error
        @notifier = notifier
      end

      def notify
        slack_notifier = Slack::Notifier.new(notifier[:options][:webhook])
        slack_notifier.ping(slack_notification_message)
      end

      private

      def slack_notification_message
        {
          blocks: [
            {
              type: 'section',
              text: {
                type: 'mrkdwn',
                text: error_message
              }
            }
          ]
        }
      end

      def error_message
        "*#{error.class_name}*: #{error.message}. \n" \
          "<#{ExceptionHunter::Engine.routes.url_helpers.error_url(error.error_group)}|Click to see the error>"
      end
    end
  end
end
