module ExceptionHunter
  class SendSlackNotificationJob < ApplicationJob
    require 'slack-notifier'

    queue_as :default

    def perform(error, notifier)
      notifier = JSON.parse(notifier, symbolize_names: true)
      webhooks = notifier.dig(:options, :webhooks)
      return if webhooks.blank?

      webhooks.each do |webhook|
        slack_notifier = Slack::Notifier.new(webhook)
        slack_notifier.ping(slack_notification_message(error))
      end
    rescue Exception # rubocop:disable Lint/RescueException
      # Suppress all exceptions to avoid loop as this would create a new error in EH.
      false
    end

    private

    def slack_notification_message(error)
      {
        blocks: [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: error_message(error)
            }
          }
        ]
      }
    end

    def error_message(error)
      "*#{error.class_name}*: #{error.message}. \n" \
        "<#{ExceptionHunter::Engine.routes.url_helpers.error_url(error.error_group)}|Click to see the error>"
    end
  end
end
