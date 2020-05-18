require 'exception_hunter/engine'
require 'exception_hunter/middleware/request_hunter'
require 'exception_hunter/middleware/sidekiq_hunter' if defined?(Sidekiq)
require 'exception_hunter/config'
require 'exception_hunter/user_attributes_collector'
require 'pagy'

module ExceptionHunter
  def self.setup(&block)
    block.call(Config)
  end

  def self.routes(router)
    router.mount(ExceptionHunter::Engine, at: 'exception_hunter')
  end
end
