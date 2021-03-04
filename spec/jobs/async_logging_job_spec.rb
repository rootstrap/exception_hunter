describe ExceptionHunter::AsyncLoggingJob, type: :job do
  let(:tag) { ExceptionHunter::ErrorCreator::HTTP_TAG }
  let(:error_attributes) do
    {
      class_name: 'SomeError',
      message: 'Something went very wrong 123',
      environment_data: {
        hide: { value_to_hide: 'hide this value' },
        "hide_this_too": 'hide this',
        hide_this_hash: { "hide_this_hash": 'hide this' }
      },
      occurred_at: Time.now
    }
  end

  before do
    ExceptionHunter::Engine.configure do |config|
      config.routes.default_url_options = { host: 'localhost:3000' }
    end

    allow(ExceptionHunter::Config).to receive(:async_logging).and_return(true)
  end

  describe '#perform' do
    subject do
      ExceptionHunter::AsyncLoggingJob.perform_now(tag, error_attributes)
    end

    context 'logs the error in an async way' do
      it 'calls ErrorCreator call' do
        expect(ExceptionHunter::ErrorCreator).to receive(:call)

        subject
      end
    end
  end
end
