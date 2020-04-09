module ExceptionHunter
  describe RequestHunter do
    let(:request_hunter) { RequestHunter.new(app) }
    let(:app) { double('Rack app') }

    describe '#call' do
      subject { request_hunter.call(env) }

      let(:env) { tracked_env.merge(not_tracked_env) }
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
        end

        it 're-raises the exception' do
          expect { subject }.to raise_error(ArgumentError)
            .with_message('Something happened on the app')
        end

        it 'creates an error record to track the exception' do
          expect {
            begin
                     subject
            rescue StandardError
              nil
                   end
          } .to change(Error, :count).by(1)
        end

        it 'tracks the configured env data' do
          begin
            subject
          rescue StandardError
            nil
          end

          error = Error.last
          expect(error.environment_data).to include(tracked_env)
        end

        it 'does not track none-configured data' do
          begin
            subject
          rescue StandardError
            nil
          end

          error = Error.last
          expect(error.environment_data).not_to include(not_tracked_env)
        end
      end
    end
  end
end
