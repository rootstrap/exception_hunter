require 'rails_helper'

describe 'GET #test', type: :request do
  let(:error) { ExceptionHunter::Error.first }
  subject { get test_path }

  before { subject }

  context 'when raising a NameError exception' do
    it 'is recorded on the db' do
      except(ExceptionHunter::Error.count).to eq(1)
    end

    it 'records class name' do
      expect(subject).to raise_error
      expect(error.class_name).to eq('NameError')
    end

    it 'records accurate ocurred_at' do
      expect(error.ocurred_at).to be_within(1.second).of(Time.now)
    end

    it 'records request correctly' do
      expect(error.environment_data['REQUEST_METHOD']). to eq('GET')
      expect(error.environment_data['PATH_INFO']). to eq('/test')
      expect(error.environment_data['HTTP_HOST']). to eq('www.example.com')
    end
  end
end
