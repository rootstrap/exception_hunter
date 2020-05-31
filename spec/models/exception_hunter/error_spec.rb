require 'rails_helper'

module ExceptionHunter
  describe Error do
    subject { build(:error) }

    describe 'validations' do
      it { is_expected.to validate_presence_of(:class_name) }
    end

    describe 'associations' do
      it { is_expected.to belong_to(:error_group) }
    end

    describe 'on creation' do
      let(:error_group) { create(:error_group) }
      let(:error) { build(:error, error_group: error_group) }

      it 'touches error group' do
        expect { error.save }.to change { error_group.reload.updated_at }
      end
    end

    describe 'occurred at' do
      let!(:error) { create(:error, occurred_at: nil) }

      context 'when creating' do
        it 'sets timestamp' do
          expect(error.occurred_at).to be_within(1.second).of(Time.now)
        end
      end

      context 'when updating' do
        it "doesn't modify timestamp" do
          expect { error.update!(class_name: 'AnotherOne') }
            .not_to change { error.reload.occurred_at }
        end
      end
    end

    describe 'most_recent' do
      let(:error_group) { create(:error_group) }
      let!(:errors) do
        [Date.yesterday, Date.today, Date.today.last_month].map do |occurred_at|
          create(:error, error_group: error_group, occurred_at: occurred_at)
        end
      end
      let!(:extra_error) { create(:error) }

      subject { Error.most_recent(error_group.id) }

      it 'returns ordered errors' do
        expect(subject.to_a.sort).to eq(errors.sort)
      end

      it 'returns only errors from error group' do
        expect(subject.to_a).not_to include(extra_error)
      end
    end

    describe 'with_occurrences_before' do
      subject { Error.with_occurrences_before(deadline) }
      let(:deadline) { 1.month.ago }

      let!(:old_errors) do
        (1..3).map do |i|
          create(:error, occurred_at: deadline - i.days)
        end
      end
      let!(:new_errors) do
        (1..3).map do |i|
          create(:error, occurred_at: deadline + i.days)
        end
      end

      it 'returns errors with occurrences before the given date' do
        expect(subject.to_a).to match_array(old_errors)
      end

      it 'does not return errors with occurrences after the given date' do
        expect(subject.to_a).not_to include(*new_errors)
      end
    end

    describe 'in_last_7_days' do
      subject { Error.in_last_7_days }
      let!(:valid_errors) do
        [
          create(:error, occurred_at: Date.current),
          create(:error, occurred_at: 3.days.ago),
          create(:error, occurred_at: 6.days.ago)
        ]
      end
      let!(:invalid_errors) do
        [
          create(:error, occurred_at: 8.days.ago),
          create(:error, occurred_at: 1.month.ago)
        ]
      end

      it 'returns error groups with errors in the last 7 days' do
        expect(subject).to include(*valid_errors)
      end

      it 'does not return error groups without errors in the last 7 days' do
        expect(subject).not_to include(*invalid_errors)
      end
    end

    describe 'in_current_month' do
      subject { Error.in_current_month }

      context 'when there are errors in the current month' do
        let!(:errors_this_month) do
          [Date.today, Date.today.beginning_of_month, Date.today.end_of_month].map do |occurred_at|
            create(:error, occurred_at: occurred_at)
          end
        end
        let!(:last_month_error) { create(:error, occurred_at: Date.today.beginning_of_month - 1.month) }
        let!(:two_months_ago_error) { create(:error, occurred_at: 2.months.ago) }

        it 'returns all errors from the current month' do
          expect(subject.to_a).to match_array(errors_this_month)
        end

        it 'does not return errors from past months' do
          expect(subject).not_to include(last_month_error)
          expect(subject).not_to include(two_months_ago_error)
        end
      end

      context 'when there are no errors in the current month' do
        it { is_expected.to be_empty }
      end
    end
  end
end
