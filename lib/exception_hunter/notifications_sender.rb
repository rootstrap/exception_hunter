module ExceptionHunter
  module NotificationsSender
    def self.notify(error)
      ExceptionHunter::Config.notifiers.each do |notifier|
        ExceptionHunter::SendSlackNotificationJob.perform_later(error, notifier.to_json) if notifier[:name] == :slack
      end
    end
  end
end
