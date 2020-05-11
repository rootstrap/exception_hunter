require 'rails_helper'

describe 'Errors', type: :request do
  describe 'show' do
    subject { get "/exception_hunter/errors/#{ExceptionHunter::Error.last.id}" }

    before do
      2.times do |i|
        create(:error_group).tap do |error_group|
          create_list(:error, i + 1, error_group: error_group)
        end
      end
    end

    it 'renders the show template' do
      subject

      expect(response).to render_template(:show)
    end
  end
end
