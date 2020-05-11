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
          create(:error, error_group_id: error_group.id, occurred_at: occurred_at)
        end
      end
      let!(:extra_error) { create(:error) }

      subject { Error.most_recent(error_group.id) }

      it 'returns ordered errors' do
        expect(subject.first.occurred_at).to eq(Date.today)
        expect(subject.last.occurred_at).to eq(Date.today.last_month)
      end

      it 'returns only errors from error group' do
        expect(subject.count).to eq(3)
      end
    end

    describe '.in_current_month' do
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
