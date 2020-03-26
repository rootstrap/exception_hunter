require 'rails_helper'
module ExceptionHunter
  describe Error do
    subject { build(:error) }

    describe 'validations' do
      it { is_expected.to validate_presence_of(:class_name) }
    end

    describe 'before validation callback' do
      before { create(:error, ocurred_at: nil) }

      context 'when creating' do
        it 'sets timestamp' do
          expect(Error.first.ocurred_at).not_to be_nil
        end
      end

      context 'when updating' do
        let(:error)       { Error.first }
        let!(:ocurred_at) { error.ocurred_at }

        it "doesn't modify timestamp" do
          error.update!(class_name: 'AnotherOne')
          expect(error.ocurred_at).to eq(ocurred_at)
        end
      end
    end
  end
end
