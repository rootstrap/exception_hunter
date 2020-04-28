module ExceptionHunter
  describe RequestHunter do
    let(:request_hunter) { RequestHunter.new(app) }
    let(:app) { double('Rack app') }
    let(:controller) { double('controller') }
    let(:user) { double('User', id: 3, email: 'example@example.com') }

    describe '#call' do
      subject { request_hunter.call(env) }

      let(:env) { tracked_env.merge(not_tracked_env).merge('action_controller.instance' => controller) }
      let(:tracked_env) do
        {
          'PATH_INFO' => '/path/to/endpoint',
          'QUERY_STRING' => 'some=value',
          'REMOTE_HOST' => 'wwww.something.io',
          'REQUEST_METHOD' => 'GET',
          'REQUEST_URI' => 'www.mysite.com/path/to/endpoint?some=value',
          'SERVER_PROTOCOL' => 'HTTP/1.1',
          'HTTP_HOST' => 'http://www.mysite.com',
          'HTTP_USER_AGENT' =>
            'Mozilla/5.0 (Windows NT 6.1; WOW64)'\
              ' AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57'
        }
      end
      let(:not_tracked_env) do
        {
          'HTTP_ACCEPT_LANGUAGE' => 'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4',
          'HTTP_CONNECTION' => 'keep-alive'
        }
      end

      context 'when the app has an exception' do
        before do
          allow(app).to receive(:call).and_raise(ArgumentError.new('Something happened on the app'))
          allow(controller).to receive(:current_user).and_return(nil)
        end

        it 're-raises the exception' do
          expect { subject }.to raise_error(ArgumentError)
            .with_message('Something happened on the app')
        end

        it 'creates an error record to track the exception' do
          expect {
            subject rescue nil
          }.to change(Error, :count).by(1)
        end

        it 'tracks the configured env data' do
          subject rescue nil

          error = Error.last
          expect(error.environment_data).to include(tracked_env)
        end

        it 'does not track none-configured data' do
          subject rescue nil

          error = Error.last
          expect(error.environment_data).not_to include(not_tracked_env)
        end

        context 'when the exception was raised by a logged user' do
          before do
            allow(controller).to receive(:current_user).and_return(user)
          end

          it 'registers user data' do
            subject rescue nil

            expect(Error.last.user_data).to include(
              { 'email' => user.email,
                'id' => user.id }
            )
          end
        end

        context 'when the exception was raised by an unlogged user' do
          before do
            allow(controller).to receive(:current_user).and_return(nil)
          end

          it 'does not register user data' do
            subject rescue nil

            expect(Error.last.user_data).to eq({})
          end
        end
      end
    end
  end
end
