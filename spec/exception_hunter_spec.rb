module ExceptionHunter
  describe ::ExceptionHunter do
    describe '.track' do
      subject { ::ExceptionHunter.track(exception, custom_data: custom_data, user: user) }

      let(:exception) do
        RuntimeError.new('Some error').tap { |exception| exception.set_backtrace(caller) }
      end
      let(:custom_data) do
        {
          some_id: 12,
          some_other_data: {
            name: 'John'
          }
        }
      end
      let(:user) { OpenStruct.new(id: 3, email: 'example@example.com', name: 'John') }

      context 'when tracking is enabled' do
        before { allow(ActiveRecord::Base.connection).to receive(:open_transactions).and_return(0) }

        let(:error) { Error.last }

        it 'creates a new error' do
          expect { subject }.to change(Error, :count).by(1)
        end

        it 'tracks the exception data' do
          subject

          expect(error.class_name).to eq(exception.class.name)
          expect(error.backtrace).to eq(exception.backtrace)
        end

        it 'tracks the custom data' do
          subject

          expect(error.custom_data).to eq({
                                            'some_id' => 12,
                                            'some_other_data' => {
                                              'name' => 'John'
                                            }
                                          })
        end

        it 'tracks the user attributes' do
          subject

          expect(error.user_data).to eq({
                                          'id' => 3,
                                          'email' => 'example@example.com'
                                        })
        end

        it 'adds the tag Manual to the error group' do
          subject

          expect(error.error_group.tags).to eq(['Manual'])
        end

        it ' does not create a new thread' do
          expect(Thread).to_not receive(:new)

          subject
        end

        context 'when the error is tracked within a transaction' do
          before do
            allow(ActiveRecord::Base.connection).to receive(:open_transactions).and_return(1)
            allow(Thread).to receive(:new).and_yield
          end

          it 'creates a new error within a new thread' do
            expect { subject }.to change(Error, :count).by(1)
            expect(Thread).to have_received(:new)
          end
        end
      end

      context 'when tracking is disabled' do
        before do
          Config.enabled = false
        end

        after do
          Config.enabled = true
        end

        it 'does not create a new error' do
          expect { subject }.not_to change(Error, :count)
        end
      end
    end

    describe '.setup' do
      let!(:original_queue_adapter) { ActiveJob::Base.queue_adapter }
      let(:notifiers) { [notifier_1, notifier_2] }

      let(:notifier_1) do
        {
          name: :slack,
          options: {
            webhook: 'test_webhook_1'
          }
        }
      end

      let(:notifier_2) do
        {
          name: :slack,
          options: {
            webhook: 'test_webhook_2'
          }
        }
      end

      before do
        ActiveJob::Base.queue_adapter = :test
      end

      after do
        ActiveJob::Base.queue_adapter = original_queue_adapter
      end

      subject do
        ExceptionHunter.setup do |config|
          config.notifiers = notifiers
        end
      end

      context 'when notifiers config is correct' do
        it 'does not raise an error' do
          expect {
            subject
          }.not_to raise_error
        end
      end

      context 'when notifiers config is not correct' do
        context 'when wrong notifier name' do
          let(:notifier_2) do
            {
              name: :slack_other,
              options: {
                webhook: 'test_webhook_2'
              }
            }
          end

          it 'raises an error' do
            expect {
              subject
            }.to raise_error(ExceptionHunter::Notifiers::MisconfiguredNotifiers) { |error|
              expect(error.message).to eq("Notifier has incorrect configuration: #{notifier_2.inspect}")
            }
          end
        end

        context 'when missing notifier webhook' do
          let(:notifier_2) do
            {
              name: :slack,
              options: {}
            }
          end

          it 'raises an error' do
            expect {
              subject
            }.to raise_error(ExceptionHunter::Notifiers::MisconfiguredNotifiers) { |error|
              expect(error.message).to eq("Notifier has incorrect configuration: #{notifier_2.inspect}")
            }
          end
        end

        context 'when missing notifier options' do
          let(:notifier_2) do
            {
              name: :slack
            }
          end

          it 'raises an error' do
            expect {
              subject
            }.to raise_error(ExceptionHunter::Notifiers::MisconfiguredNotifiers) { |error|
              expect(error.message).to eq("Notifier has incorrect configuration: #{notifier_2.inspect}")
            }
          end
        end

        context 'when missing notifier name' do
          let(:notifier_2) do
            {
              options: {
                webhook: 'test_webhook_2'
              }
            }
          end

          it 'raises an error' do
            expect {
              subject
            }.to raise_error(ExceptionHunter::Notifiers::MisconfiguredNotifiers) { |error|
              expect(error.message).to eq("Notifier has incorrect configuration: #{notifier_2.inspect}")
            }
          end
        end
      end
    end
  end
end
