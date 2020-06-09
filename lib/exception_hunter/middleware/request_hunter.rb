module ExceptionHunter
  module Middleware
    class RequestHunter
      ENVIRONMENT_KEYS =
        %w[PATH_INFO
           QUERY_STRING
           REMOTE_HOST
           REQUEST_METHOD
           REQUEST_URI
           SERVER_PROTOCOL
           HTTP_HOST
           CONTENT_TYPE
           HTTP_USER_AGENT].freeze

      FILTERED_PARAMS = [/password/].freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      rescue Exception => exception # rubocop:disable Lint/RescueException
        catch_prey(env, exception)
        raise exception
      end

      private

      def catch_prey(env, exception)
        user = user_from_env(env)
        ErrorCreator.call(
          tag: ErrorCreator::HTTP_TAG,
          class_name: exception.class.to_s,
          message: exception.message,
          environment_data: environment_data(env),
          backtrace: exception.backtrace,
          user: user
        )
      end

      def environment_data(env)
        env
          .select { |key, _value| ENVIRONMENT_KEYS.include?(key) }
          .merge(params: filtered_sensitive_params(env))
      end

      def user_from_env(env)
        current_user_method = Config.current_user_method
        controller = env['action_controller.instance']
        controller.try(current_user_method)
      end

      def filtered_sensitive_params(env)
        params = env['action_dispatch.request.parameters']
        parameter_filter = ::ActiveSupport::ParameterFilter.new(FILTERED_PARAMS)
        parameter_filter.filter(params || {})
      end
    end
  end
end

module ExceptionHunter
  class Railtie < Rails::Railtie
    initializer 'exception_hunter.add_middleware', after: :load_config_initializers do |app|
      app.config.middleware.insert_after(
        ActionDispatch::DebugExceptions, ExceptionHunter::Middleware::RequestHunter
      )
    end
  end
end
