require 'rails_helper'

describe 'Errors', type: :request do
  let(:controller) { ExceptionHunter::ErrorsController }

  describe 'index' do
    subject { get '/exception_hunter' }

    before do
      (1..3).each do |i|
        create(:error_group).tap do |error_group|
          create_list(:error, i, error_group: error_group)
        end
      end
    end
    context 'when logged in' do
      let(:admin) { create(:admin_user) }
      before { sign_in(admin) }

      it 'renders the index template' do
        subject

        expect(response).to render_template(:index)
      end
    end

    context 'when logged out' do
      it 'redirects to login' do
        expect(subject).to redirect_to(new_admin_user_session_path)
      end
    end
  end

  describe 'show' do
    let(:error_group) { create(:error_group) }

    subject { get "/exception_hunter/errors/#{error_group.id}" }

    before do
      create_list(:error, 2, error_group: error_group)
    end

    context 'when logged in' do
      let(:admin) { create(:admin_user) }
      before { sign_in(admin) }

      it 'renders the show template' do
        subject

        expect(response).to render_template(:show)
      end
    end

    context 'when logged out' do
      it 'redirects to login' do
        expect(subject).to redirect_to(new_admin_user_session_path)
      end
    end
  end
end
