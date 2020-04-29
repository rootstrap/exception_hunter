require_dependency 'exception_hunter/railtie'

module ExceptionHunter
  class Engine < ::Rails::Engine
    isolate_namespace ExceptionHunter

    config.generators do |gen|
      gen.test_framework :rspec
      gen.fixture_replacement :factory_bot
      gen.factory_bot dir: 'spec/factories'
    end
  end
end
