module ExceptionHunter
  describe ErrorGroup do
    describe 'validations' do
      subject { build(:error_group) }

      it { is_expected.to validate_presence_of(:error_class_name) }
    end

    describe 'associations' do
      it { is_expected.to have_many(:grouped_errors) }
    end

    describe 'most_similar' do
      subject { ErrorGroup.most_similar(message) }

      let(:message) { 'Some error message 1234' }
      let!(:equal_error) { create(:error_group, message: 'Some error message 1234') }
      let!(:similar_error) { create(:error_group, message: 'Some error message 123') }
      let!(:non_similar_error) { create(:error_group, message: 'Something different') }

      it 'returns error groups similar error messages ordered by similarity' do
        expect(subject.to_a).to eq([equal_error, similar_error])
      end
    end

    describe '#last_occurence' do
      subject { error_group.last_occurrence }

      let(:error_group) { create(:error_group, grouped_errors: [last_error, older_error]) }
      let(:last_error) { create(:error, occurred_at: 1.week.ago) }
      let(:older_error) { create(:error, occurred_at: 2.weeks.ago) }

      it 'returns the maximum occurrence from the grouped errors' do
        expect(subject).to be_within(1.second).of(last_error.occurred_at)
      end
    end

    describe '#total_occurrences' do
      subject { error_group.total_occurrences }

      let(:error_group) { create(:error_group, grouped_errors: grouped_errors) }
      let(:grouped_errors) { create_list(:error, 4) }

      it 'returns the total number of grouped errors' do
        expect(subject).to eq(4)
      end
    end

    describe '.find_matching_group' do
      subject { ErrorGroup.find_matching_group(error) }

      let(:error) { create(:error, class_name: 'SomeError', message: 'Some error message') }

      context 'when there is an error group with the same error class' do
        context 'when the error group has a similar error message' do
          let!(:error_group) { create(:error_group, error_class_name: 'SomeError', message: 'Some error message') }

          it 'returns the matching error group' do
            expect(subject).to eq(error_group)
          end
        end

        context 'when the error group has a different error message' do
          before do
            create(:error_group, error_class_name: 'SomeError', message: 'Something different')
          end

          it { is_expected.to be_nil }
        end
      end

      context 'when there is an error group with a different error class' do
        before do
          create(:error_group, error_class_name: 'AnotherError')
        end

        it { is_expected.to be_nil }
      end
    end
  end
end
