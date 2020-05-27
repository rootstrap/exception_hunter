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
  end
end
