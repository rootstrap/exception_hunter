require 'sidekiq'
require 'exception_hunter/middleware/sidekiq_hunter'

module ExceptionHunter
  module Middleware
    describe SidekiqHunter do
      describe '#call' do
        subject { SidekiqHunter.new.call(nil, worker_context, nil) { worker.call } }
        let(:worker_context) do
          job_data.merge('args' => [worker_arguments])
        end
        let(:job_data) do
          {
            'queue' => 'default',
            'other_stuff' => 'not to track'
          }
        end
        let(:worker_arguments) do
          {
            'job_class' => 'SomeJob',
            'job_id' => '63cbbe43-8dd2-40c3-9790-9f90009588ba',
            'arguments' => ['143', 'User', 42],
            'enqueued_at' => '2020-05-18T02:23:30Z',
            'much_more_data' => 'not to track'
          }
        end

        context 'when the worker raises an exception' do
          let(:worker) { -> { raise 'Some error' } }

          it 're-raises the exception' do
            expect { subject }.to raise_error(RuntimeError, 'Some error')
          end

          it 'tracks the error' do
            expect { subject rescue nil } .to change(Error, :count).by(1)
          end

          it 'tracks data from the context' do
            subject rescue nil

            error = Error.last
            expect(error.environment_data).to eq({
                                                   'queue' => 'default',
                                                   'job_class' => 'SomeJob',
                                                   'job_id' => '63cbbe43-8dd2-40c3-9790-9f90009588ba',
                                                   'arguments' => ['143', 'User', 42],
                                                   'enqueued_at' => '2020-05-18T02:23:30Z'
                                                 })
          end

          it 's error group has Worker tag' do
            subject rescue nil

            error = Error.last
            expect(error.error_group.tags).to eq(['Worker'])
          end
        end

        context 'when the worker is retrying' do
          context 'with a tracked retry' do
            let(:job_data) do
              {
                'queue' => 'default',
                'retry_count' => '3'
              }
            end

            it 'tracks the error' do
              expect { subject rescue nil } .to change(Error, :count).by(1)
            end
          end

          context 'with un un-tracked retry' do
            let(:job_data) do
              {
                'queue' => 'default',
                'retry_count' => '2'
              }
            end

            it 'does not create an error' do
              expect { subject rescue nil } .not_to change(Error, :count)
            end
          end
        end

        context 'when the worker does not raise an exception' do
          let(:worker) { -> {} }

          it 'does not create an error' do
            expect { subject rescue nil } .not_to change(Error, :count)
          end
        end
      end
    end
  end
end
