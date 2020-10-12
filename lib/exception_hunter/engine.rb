module ExceptionHunter
  # @private
  class Engine < ::Rails::Engine
    isolate_namespace ExceptionHunter

    config.generators do |gen|
      gen.test_framework :rspec
      gen.fixture_replacement :factory_bot
      gen.factory_bot dir: 'spec/factories'
    end

    initializer 'exception_hunter.precompile', group: :all do |app|
      app.config.assets.precompile << 'exception_hunter/application.css'
      app.config.assets.precompile << 'exception_hunter/logo.png'
    end

    initializer 'exception_hunter.load_middleware', group: :all do
      require 'exception_hunter/middleware/sidekiq_hunter' if defined?(Sidekiq)
      require 'exception_hunter/middleware/delayed_job_hunter' if defined?(Delayed)
    end
  end
end
