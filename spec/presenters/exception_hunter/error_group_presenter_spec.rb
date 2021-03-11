module ExceptionHunter
  describe ErrorGroupPresenter do
    describe '.wrap_collection' do
      let(:error_groups) { create_list(:error_group, 3) }

      it 'returns an array of ErrorGroupPresenters' do
        expect(ErrorGroupPresenter.wrap_collection(error_groups)).to all(be_an ErrorGroupPresenter)
      end
    end

    describe '.format_occurrence_day' do
      let(:day) { Date.new(2020, 5, 30) }

      it 'returns the last occurrence date formatted as a string' do
        expect(ErrorGroupPresenter.format_occurrence_day(day)).to eq('Saturday, May 30')
      end

      context 'when the last occurrence happened yesterday' do
        let(:day) { Date.yesterday }

        it 'returns Yesterday instead of the date formatted as a string' do
          expect(ErrorGroupPresenter.format_occurrence_day(day)).to eq('Yesterday')
        end
      end
    end

    describe '#show_for_day?' do
      subject { presenter.show_for_day?(day) }
      let(:presenter) { ErrorGroupPresenter.new(error_group) }
      let(:error_group) { create(:error_group) }
      let(:day) { Date.yesterday }

      context 'when the last occurrence is on the day' do
        before do
          create(:error, occurred_at: day, error_group: error_group)
        end

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when the last occurrence is not on the day' do
        before do
          create(:error, occurred_at: day - 1.day, error_group: error_group)
        end

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end
  end
end
