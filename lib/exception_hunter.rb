require 'pagy'

require 'exception_hunter/engine'
require 'exception_hunter/middleware/request_hunter'
require 'exception_hunter/config'
require 'exception_hunter/error_creator'
require 'exception_hunter/error_reaper'
require 'exception_hunter/tracking'
require 'exception_hunter/user_attributes_collector'
require 'exception_hunter/notifiers/slack_notifier'
require 'exception_hunter/notifiers/serializers/slack_notifier_serializer'
require 'exception_hunter/notifiers/exceptions/misconfigured_notifiers.rb'

module ExceptionHunter
  autoload :Devise, 'exception_hunter/devise'

  extend ::ExceptionHunter::Tracking

  def self.setup(&block)
    block.call(Config)
    validate_config!
  end

  def self.routes(router)
    return unless Config.enabled

    router.mount(ExceptionHunter::Engine, at: 'exception_hunter')
  end

  def self.validate_config!
    notifiers = Config.notifiers
    return if notifiers.blank?

    notifiers.each do |notifier|
      next if notifier[:name] == :slack && notifier.dig(:options, :webhook).present?

      raise ExceptionHunter::Notifiers::Exceptions::MisconfiguredNotifiers, notifier
    end
  end
end
