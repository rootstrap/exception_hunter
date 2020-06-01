require 'rails_helper'

describe 'Errors', type: :request do
  describe 'index' do
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
  end

  describe 'resolve' do
    let(:error_group) { create(:error_group) }

    subject { get "/exception_hunter/errors/#{error_group.id}/resolve" }

    it 'resolves the error group' do
      expect { subject }.to change { error_group.reload.resolved }.from(false).to(true)
    end

    it 'redirects back' do
      subject

      expect(response).to have_http_status(302)
    end

    context 'on new error creation' do
      before { get "/exception_hunter/errors/#{error_group.id}/resolve" }

      subject { create(:error, error_group: error_group) }

      it 'unresolves error' do
        expect { subject }.to change { error_group.reload.resolved }.from(true).to(false)
      end
    end
  end
end
