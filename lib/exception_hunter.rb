require 'exception_hunter/engine'
require 'exception_hunter/railtie'
require 'exception_hunter/config'
require 'exception_hunter/user_attributes_collector'
require 'pagy'

module ExceptionHunter
  autoload :Devise, 'exception_hunter/devise'

  def self.setup(&block)
    block.call(Config)
  end

  def self.routes(router)
    router.mount(ExceptionHunter::Engine, at: 'exception_hunter')
  end
end
