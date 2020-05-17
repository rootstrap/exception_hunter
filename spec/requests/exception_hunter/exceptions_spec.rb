require 'rails_helper'

module ExceptionHunter
  describe 'GET #raising_endpoint' do
    subject { get raising_endpoint_path, params: params }
    let(:params) do
      {
        'some_id' => 3,
        'some_data' => {
          'name' => 'John',
          'email' => 'invalid-email.com'
        }
      }
    end

    it 'creates a record to track the error' do
      expect { subject }.to change { Error.count }.by(1)
    end

    describe 'tracked data' do
      let(:error) { Error.last }

      before do
        subject
      end

      it 'tracks the correct class name' do
        expect(error.class_name).to eq(ArgumentError.to_s)
      end

      it 'tracks the error message' do
        expect(error.message).to eq('You should not have called me')
      end

      it 'tracks the occurrence time' do
        expect(error.occurred_at).to be_within(1.second).of(Time.now)
      end

      it 'tracks the environment data' do
        expect(error.environment_data).to include(
          'HTTP_HOST' => 'www.example.com',
          'PATH_INFO' => '/raising_endpoint',
          'QUERY_STRING' => 'some_id=3&some_data[name]=John&some_data[email]=invalid-email.com',
          'REQUEST_METHOD' => 'GET',
          'REQUEST_URI' => '/raising_endpoint'
        )
      end
    end
  end

  describe 'POST #broken_post' do
    subject { post broken_post_path(some_query_param: 'I go in the URL'), params: params }
    let(:params) do
      {
        'some_id' => 3,
        'some_data' => {
          'name' => 'John',
          'email' => 'invalid-email.com'
        }
      }
    end
    let(:error) { Error.last }

    before do
      subject
    end

    it 'tracks the params' do
      expect(error.environment_data['params']).to eq({
                                                       'some_id' => '3',
                                                       'some_query_param' => 'I go in the URL',
                                                       'action' => 'broken_post',
                                                       'controller' => 'exception',
                                                       'some_data' => {
                                                         'name' => 'John',
                                                         'email' => 'invalid-email.com'
                                                       }
                                                     })
    end
  end
end
