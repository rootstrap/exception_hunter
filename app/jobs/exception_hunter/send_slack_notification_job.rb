module ExceptionHunter
  class SendSlackNotificationJob < ApplicationJob
    queue_as :default

    def perform(error)
      notifier = Slack::Notifier.new(ENV.fetch('SLACK_WEBHOOK_URL'))
      notifier.ping(slack_notification_message(error))
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
