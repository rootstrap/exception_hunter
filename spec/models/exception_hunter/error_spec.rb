require 'rails_helper'
module ExceptionHunter
  describe Error do
    subject { build(:error) }

    describe 'validations' do
      it { is_expected.to validate_presence_of(:class_name) }
    end

    describe 'ocurred at' do
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
  end
end
