module ExceptionHunter
  describe NotificationsSender do
    describe '.notify' do
      let(:error)                   { create(:error) }
      let!(:original_queue_adapter) { ActiveJob::Base.queue_adapter }

      let(:notifiers) do
        [
          {
            name: :slack,
            options: {
              webhooks: ['test_webhook']
            }
          },
          {
            name: :mail
          }
        ]
      end

      before do
        ActiveJob::Base.queue_adapter = :test

        allow(ExceptionHunter::Config)
          .to receive(:notifiers)
          .and_return(notifiers)
      end

      after do
        ActiveJob::Base.queue_adapter = original_queue_adapter
      end

      subject do
        ExceptionHunter::NotificationsSender.notify(error)
      end

      it 'enqueues job to send slack message' do
        expect {
          subject
        }.to have_enqueued_job(SendSlackNotificationJob).with(error, notifiers.first.to_json)
      end

      it 'does not enqueue job to send email message' do
        expect {
          subject
        }.not_to have_enqueued_job(SendSlackNotificationJob).with(error, notifiers.last.to_json)
      end
    end
  end
end
