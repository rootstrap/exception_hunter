require 'exception_hunter/engine'
require 'exception_hunter/railtie'
require 'exception_hunter/config'
require 'exception_hunter/collector/user_attributes_collector'

module ExceptionHunter
  def self.setup(&block)
    block.call(Config)
  end
end
