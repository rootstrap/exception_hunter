module ExceptionHunter
  class RequestHunter
    ENVIRONMENT_KEYS =
      %w[PATH_INFO QUERY_STRING REMOTE_HOST REQUEST_METHOD REQUEST_URI
         SERVER_PROTOCOL HTTP_HOST HTTP_USER_AGENT HTTP_COOKIE].freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      catch_prey(env, exception)
      raise exception
    end

    private

    def catch_prey(env, exception)
      ExceptionHunter::Error.create!(
        class_name: exception.class.to_s,
        message: exception.message,
        environment_data: environment_data(env),
        backtrace: exception.backtrace
      )
    end

    def environment_data(env)
      env.select { |key, _value| ENVIRONMENT_KEYS.include?(key) }
    end
  end
end
