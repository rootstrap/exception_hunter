module ExceptionHunter
  class RequestHunter
    ENVIRONMENT_KEYS =
      %w[PATH_INFO QUERY_STRING REMOTE_HOST REQUEST_METHOD REQUEST_URI
         SERVER_PROTOCOL HTTP_HOST HTTP_USER_AGENT].freeze

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
      user = user_from_env(env)
      ErrorCreator.call(
        class_name: exception.class.to_s,
        message: exception.message,
        environment_data: environment_data(env),
        backtrace: exception.backtrace,
        user: user
      )
    end

    def environment_data(env)
      env.select { |key, _value| ENVIRONMENT_KEYS.include?(key) }
    end

    def user_from_env(env)
      current_user_method = Config.current_user_method
      controller = env['action_controller.instance']
      controller.try(current_user_method)
    end
  end
end
