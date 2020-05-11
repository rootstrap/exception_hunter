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
  end
end
