require 'rails_helper'

module ExceptionHunter
  describe ErrorPresenter do
    let!(:error) { create(:error) }

    let(:error_presenter) { ErrorPresenter.new(error) }

    it 'returns id correctly' do
      expect(error_presenter.id).to eq(error.id)
    end

    it 'returns message correctly' do
      expect(error_presenter.message).to eq(error.message)
    end

    it 'returns occurred at correctly' do
      expect(error_presenter.occurred_at).to eq(error.occurred_at)
    end

    it 'returns environment data correctly' do
      expect(error_presenter.environment_data).to eq(error.environment_data)
    end

    it 'returns custom data parameter correctly' do
      expect(error_presenter.custom_data).to eq(error.custom_data)
    end
  end
end
