module ExceptionHunter
  describe ErrorCreator do
    describe '.call' do
      subject { described_class.call(error_attributes) }

      context 'with correct attributes' do
        let(:error_attributes) do
          { class_name: 'SomeError', message: 'Something went very wrong 123' }
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
            expect(subject).to eq(Error.first)
          end

          it 'binds the error to the error group ' do
            subject
            expect(Error.last.error_group).to eq(error_group)
          end

          it 'updates the error message' do
            expect { subject }.to change { error_group.reload.message }.to('Something went very wrong 123')
          end
        end

        context 'without a matching error group' do
          it 'creates an error' do
            expect { subject }.to change(Error, :count).by(1)
          end

          it 'returns the error' do
            expect(subject).to eq(Error.first)
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
    end
  end
end
