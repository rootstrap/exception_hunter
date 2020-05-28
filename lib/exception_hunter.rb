require 'pagy'

require 'exception_hunter/engine'
require 'exception_hunter/middleware/request_hunter'
require 'exception_hunter/middleware/sidekiq_hunter' if defined?(Sidekiq)
require 'exception_hunter/config'
require 'exception_hunter/error_creator'
require 'exception_hunter/error_reaper'
require 'exception_hunter/tracking'
require 'exception_hunter/user_attributes_collector'

module ExceptionHunter
  autoload :Devise, 'exception_hunter/devise'

  extend ::ExceptionHunter::Tracking

  def self.setup(&block)
    block.call(Config)
  end

  def self.routes(router)
    router.mount(ExceptionHunter::Engine, at: 'exception_hunter')
  end
end
