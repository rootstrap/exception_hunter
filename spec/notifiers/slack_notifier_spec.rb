describe ExceptionHunter::Notifiers::SlackNotifier do
  let(:error_group) { create(:error_group) }
  let(:error) { create(:error, error_group: error_group) }
  let(:slack_notifier) { ExceptionHunter::Notifiers::SlackNotifier.new(error, notifier) }

  let(:notifier) do
    {
      name: :slack,
      options: {
        webhook: 'test_webhook'
      }
    }
  end

  let(:notification_message) do
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

  let(:error_message) do
    "*#{error.class_name}*: #{error.message}. \n" \
      "<#{ExceptionHunter::Engine.routes.url_helpers.error_url(error.error_group)}|Click to see the error>"
  end

  before do
    ExceptionHunter::Engine.configure do |config|
      config.routes.default_url_options = { host: 'localhost:3000' }
    end
  end

  describe '#notify' do
    subject do
      slack_notifier.notify
    end

    context 'sends notification to slack' do
      it 'calls Slack::Notifier' do
        expect_any_instance_of(Slack::Notifier)
          .to receive(:ping)
          .with(notification_message)

        subject
      end
    end
  end
end
