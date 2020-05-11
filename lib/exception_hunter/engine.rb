require 'rubygems'
require 'pagy'

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
