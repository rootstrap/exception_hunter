describe ExceptionHunter::SendSlackNotificationJob, type: :job do
  let(:error_group) { create(:error_group) }
  let(:error)       { create(:error, error_group: error_group) }

  let(:notifier) do
    {
      name: :slack,
      options: {
        webhooks: ['test_webhook']
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

  describe '#perform' do
    subject do
      ExceptionHunter::SendSlackNotificationJob.perform_now(error, notifier.to_json)
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
