describe ExceptionHunter::SendNotificationJob, type: :job do
  let(:error) { create(:error) }
  let(:slack_notifier) { ExceptionHunter::Notifiers::SlackNotifier.new(error, notifier) }
  let(:serialized_slack_notifier) { ExceptionHunter::Serializers::SlackNotifierSerializer.serialize(slack_notifier) }

  let(:notifier) do
    {
      name: :slack,
      options: {
        webhook: 'test_webhook'
      }
    }
  end

  before do
    ExceptionHunter::Engine.configure do |config|
      config.routes.default_url_options = { host: 'localhost:3000' }
    end
  end

  describe '#perform' do
    subject do
      ExceptionHunter::SendNotificationJob.perform_now(serialized_slack_notifier)
    end

    context 'sends notification to slack' do
      it 'calls ExceptionHunter::Notifiers::SlackNotifier notify' do
        expect_any_instance_of(ExceptionHunter::Notifiers::SlackNotifier)
          .to receive(:notify)

        subject
      end
    end
  end
end
