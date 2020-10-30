module ExceptionHunter
  describe ErrorCreator do
    describe '.call' do
      subject { described_class.call(error_attributes) }

      context 'with correct attributes' do
        let(:error_attributes) do
          {
            class_name: 'SomeError',
            message: 'Something went very wrong 123',
            environment_data: {
              hide: { value_to_hide: 'hide this value' },
              "hide_this_too": 'hide this',
              hide_this_hash: { "hide_this_hash": 'hide this' }
            }
          }
        end

        context 'with a matching error group' do
          let!(:error_group) do
            create(:error_group,
                   error_class_name: 'SomeError',
                   message: 'Something went very wrong 567')
          end

          it 'creates an error ' do
            expect { subject }.to change(Error, :count).by(1)
          end

          it 'returns the error' do
            expect(subject).to be_an(Error)
          end

          it 'binds the error to the error group ' do
            subject
            expect(Error.last.error_group).to eq(error_group)
          end

          it 'updates the error message' do
            expect { subject }.to change { error_group.reload.message }.to('Something went very wrong 123')
          end

          context 'with repeating tag' do
            before do
              error_attributes[:tag] = ErrorCreator::HTTP_TAG
              described_class.call(error_attributes)
            end

            it 'does not repeat tags' do
              expect(error_group.reload.tags).to eq(['HTTP'])

              subject

              expect(error_group.reload.tags).to eq(['HTTP'])
            end
          end

          context 'with value to hide' do
            before do
              allow(ExceptionHunter::Config)
                .to receive(:sensitive_fields)
                .and_return(%i[value_to_hide hide_this hide_this_hash])

              subject
            end

            it 'saves the error with hidden values' do
              environment_data = Error.last.environment_data
              expect(environment_data['hide']['value_to_hide']).to eq('[FILTERED]')
              expect(environment_data['hide_this_too']).to eq('[FILTERED]')
              expect(environment_data['hide_this_hash']).to eq('[FILTERED]')
            end
          end

          context 'with slack notifications' do
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

              allow(ExceptionHunter::Config)
                .to receive(:notifiers)
                .and_return(notifiers)
            end

            after do
              ActiveJob::Base.queue_adapter = original_queue_adapter
            end

            it 'enqueues job to send slack message to all webhooks' do
              subject
              jobs = ActiveJob::Base.queue_adapter.enqueued_jobs.map do |job|
                (job['arguments'] || job[:args]).last['notifier']['options']['webhook']
              end

              expect(jobs).to contain_exactly('test_webhook_1', 'test_webhook_2')
            end
          end
        end

        context 'without a matching error group' do
          it 'creates an error' do
            expect { subject }.to change(Error, :count).by(1)
          end

          it 'returns the error' do
            expect(subject).to be_an(Error)
          end

          it 'creates an error group and binds the error to it' do
            expect { subject }.to change(ErrorGroup, :count).by(1)
            expect(Error.last.error_group).to eq(ErrorGroup.last)
          end
        end
      end

      context 'with incorrect attributes' do
        let(:error_attributes) do
          { class_name: nil }
        end

        it 'returns false' do
          expect(subject).to be false
        end

        it 'does not create a new error' do
          expect { subject }.not_to change(Error, :count)
        end

        it 'does not create an error group' do
          expect { subject }.not_to change(ErrorGroup, :count)
        end
      end

      context 'when error tracking is disabled' do
        let(:error_attributes) do
          { class_name: 'SomeError', message: 'Something went very wrong 123' }
        end

        before do
          Config.enabled = false
        end

        after do
          Config.enabled = true
        end

        it 'does not track errors' do
          expect { subject }.not_to change(Error, :count)
        end
      end

      context 'ignored errors' do
        let(:error_attributes) do
          { class_name: 'SomeError', message: 'Something went very wrong 123' }
        end

        let!(:ignored_error_group) do
          create(:error_group, :ignored_group,
                 error_class_name: 'SomeError',
                 message: 'Something went very wrong 567')
        end
        it 'returns nil' do
          expect(subject).to be_nil
        end

        it 'creates an error ' do
          expect { subject }.to change(Error, :count).by(1)
          expect(ErrorGroup.last.status).to eq(ErrorGroup.ignored.last.status)
        end
      end
    end
  end
end
