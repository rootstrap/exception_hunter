require 'pagy'

require 'exception_hunter/engine'
require 'exception_hunter/middleware/request_hunter'
require 'exception_hunter/config'
require 'exception_hunter/error_creator'
require 'exception_hunter/error_reaper'
require 'exception_hunter/tracking'
require 'exception_hunter/user_attributes_collector'
require 'exception_hunter/notifiers/slack_notifier'
require 'exception_hunter/notifiers/slack_notifier_serializer'
require 'exception_hunter/notifiers/misconfigured_notifiers'

# @api public
module ExceptionHunter
  autoload :Devise, 'exception_hunter/devise'

  extend ::ExceptionHunter::Tracking

  # Used to setup ExceptionHunter's configuration
  # it receives a block with the {ExceptionHunter::Config} singleton
  # class.
  #
  # @return [void]
  def self.setup(&block)
    block.call(Config)
    validate_config!
  end

  # Mounts the ExceptionHunter dashboard at /exception_hunter
  # if it's enabled on the current environment.
  #
  # @example
  #   Rails.application.routes.draw do
  #     ExceptionHunter.routes(self)
  #   end
  #
  # @param [ActionDispatch::Routing::Mapper] router to mount to
  # @return [void]
  def self.routes(router)
    return unless Config.enabled

    router.mount(ExceptionHunter::Engine, at: 'exception_hunter')
  end

  # @private
  def self.validate_config!
    notifiers = Config.notifiers
    return if notifiers.blank?

    notifiers.each do |notifier|
      next if notifier[:name] == :slack && notifier.dig(:options, :webhook).present?

      raise ExceptionHunter::Notifiers::MisconfiguredNotifiers, notifier
    end
  end
end
