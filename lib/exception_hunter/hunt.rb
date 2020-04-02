module ExceptionHunter
  class Hunt
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => e
      catch_prey(env, e)
      raise ex
    end

    private

    def catch_prey(env, exception)
      ExceptionHunter::Error.create!(
        class_name: class_name(exception.inspect),
        message: exception.message,
        environment_data: environment_data(env),
        backtrace: exception.backtrace
      )
    end

    def class_name(exception)
      exception.sub(/^\#</i, '').sub(/\: .*/i, '')
    end

    def environment_data(env)
      env.select { |key, _value| environment_keys.include?(key) }
    end

    def environment_keys
      %w[
        PATH_INFO
        QUERY_STRING
        REMOTE_HOST
        REQUEST_METHOD
        REQUEST_URI
        SERVER_PROTOCOL
        HTTP_HOST
        HTTP_USER_AGENT
        HTTP_COOKIE
      ]
    end
  end
end
