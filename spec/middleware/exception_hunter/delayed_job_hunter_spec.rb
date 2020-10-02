require 'delayed_job'
require 'exception_hunter/middleware/delayed_job_hunter'

module ExceptionHunter
  describe Middleware::DelayedJobHunter do
    before do
      Delayed::Worker.delay_jobs = false
    end

    context 'with an ActiveJob' do
      subject { worker.perform_later(1, 'a') }

      let(:worker) do
        Class.new(ActiveJob::Base) do
          def perform(*)
            raise StandardError, 'Something happened!!!!'
          end
        end
      end

      it 'tracks exceptions on failing workers' do
        expect { subject rescue StandardError }.to change(Error, :count).by(1)
      end

      it 'tracks the correct data' do
        subject rescue StandardError

        error = Error.last

        expect(error.environment_data).to include({
                                                    'arguments' => [1, 'a'],
                                                    'job_class' => 'ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper',
                                                    'queue_name' => 'default'
                                                  })
        if Gem::Version.new(Rails.version) >= Gem::Version.new('6')
          expect(error.environment_data['enqueued_at']).not_to be_nil
        end
        expect(error.environment_data['job_id']).not_to be_nil
      end
    end

    context 'with a normal class' do
      subject { worker_class.new.delay.raising_method }

      let(:worker_class) do
        Struct.new(:name) do
          def raising_method
            raise StandardError, 'Something happened!!!!'
          end
        end
      end
      let(:worker) { worker_class.new }

      it 'tracks exceptions on failing workers' do
        expect { subject rescue StandardError }.to change(Error, :count).by(1)
      end

      it 'tracks the correct data' do
        subject rescue StandardError

        error = Error.last

        expect(error.environment_data).to eq({
                                               'attempts' => 0,
                                               'job_class' => 'Delayed::PerformableMethod'
                                             })
      end
    end
  end
end
