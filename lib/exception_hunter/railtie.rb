require_dependency 'exception_hunter/request_hunter'
module ExceptionHunter
  class Railtie < Rails::Railtie
    initializer 'exception_hunter.add_middleware', after: :load_config_initializers do |app|
      app.config.middleware.insert_after(
        ActionDispatch::DebugExceptions, ExceptionHunter::RequestHunter
      )
    end
  end
end
