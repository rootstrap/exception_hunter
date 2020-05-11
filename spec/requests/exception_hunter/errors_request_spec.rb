require 'rails_helper'

describe 'Errors', type: :request do
  describe 'index' do
    subject { get '/exception_hunter/errors' }

    before do
      3.times do |i|
        create(:error_group).tap do |error_group|
          create_list(:error, i + 1, error_group: error_group)
        end
      end
    end

    it 'renders the index template' do
      subject

      expect(response).to render_template(:index)
    end
  end
end
