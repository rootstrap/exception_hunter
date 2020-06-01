require 'rails_helper'

module ExceptionHunter
  describe 'Errors', type: :request do
    describe 'GET /exception_hunter/errors' do
      subject { get '/exception_hunter/errors' }

      before do
        (1..3).each do |i|
          create(:error_group).tap do |error_group|
            create_list(:error, i, error_group: error_group)
          end
        end
      end

      it 'renders the index template' do
        subject

        expect(response).to render_template(:index)
      end
    end

    describe 'GET /exception_hunter/errors/:id' do
      let(:error_group) { create(:error_group) }

      subject { get "/exception_hunter/errors/#{error_group.id}" }

      before do
        create_list(:error, 2, error_group: error_group)
      end

      it 'renders the show template' do
        subject

        expect(response).to render_template(:show)
      end
    end

    describe 'DELETE /exception_hunter/errors/purge' do
      subject { delete '/exception_hunter/errors/purge' }

      it 'calls the ErrorReaper' do
        expect(ErrorReaper).to receive(:purge)

        subject
      end

      it 'redirects back' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end
end
