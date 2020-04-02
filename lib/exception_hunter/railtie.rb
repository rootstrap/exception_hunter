require_dependency 'exception_hunter/hunt'
module ExceptionHunter
  class Railtie < Rails::Railtie
    initializer 'hunt.add_middleware', after: :load_config_initializers do |app|
      app.config.middleware.insert_after(ActionDispatch::DebugExceptions, ExceptionHunter::Hunt)
    end
  end
end
