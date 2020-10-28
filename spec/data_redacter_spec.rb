module ExceptionHunter
  describe DataRedacter do
    describe '.redact' do
      subject { described_class.redact(attributes, attributes_to_filter) }

      let(:attributes_to_filter) { %i[class_name hide hide_this_too hide_this_hash] }

      context 'when params with content' do
        let(:attributes) do
          {
            class_name: 'SomeError',
            message: 'Something went very wrong 123',
            environment_data: {
              hide: { value_to_hide: 'hide this value' },
              "hide_this_too": { "hide_this": 'hide this' },
              hide_this_hash: { "hide_this_hash": 'hide this' }
            }
          }
        end

        it 'hides the values' do
          expect(subject).to eq(
            class_name: '[FILTERED]',
            message: 'Something went very wrong 123',
            environment_data: {
              hide: '[FILTERED]',
              "hide_this_too": '[FILTERED]',
              hide_this_hash: '[FILTERED]'
            }
          )
        end
      end

      context 'when empty params' do
        context 'when params is an empty hash' do
          let(:attributes) { {} }

          it 'returns empty hash' do
            expect(subject).to eq({})
          end
        end

        context 'when params is an empty string' do
          let(:attributes) { '' }

          it 'returns empty string' do
            expect(subject).to eq('')
          end
        end

        context 'when params is null' do
          let(:attributes) { nil }

          it 'returns nil' do
            expect(subject).to eq(nil)
          end
        end
      end
    end
  end
end
