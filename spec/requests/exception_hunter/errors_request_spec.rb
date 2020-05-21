require 'rails_helper'

describe 'Errors', type: :request do
  let(:controller) { ExceptionHunter::ErrorsController }
  before { controller.skip_before_action :authenticate_admin_user_class, raise: false }

  describe 'index' do
    subject { get '/exception_hunter/' }

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

    context 'when logged out' do
      before { controller.before_action :authenticate_admin_user_class }

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

    it 'renders the show template' do
      subject

      expect(response).to render_template(:show)
    end

    context 'when logged out' do
      before { controller.before_action :authenticate_admin_user_class }

      it 'redirects to login' do
        expect(subject).to redirect_to(new_admin_user_session_path)
      end
    end
  end
end
