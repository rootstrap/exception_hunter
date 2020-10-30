module ExceptionHunter
  # Config singleton class used to customize ExceptionHunter
  class Config
    # @!attribute
    # @return [Boolean] whether ExceptionHunter is active or not
    cattr_accessor :enabled, default: true
    # @!attribute
    # @return [String] the name of the admin class (generally AdminUser)
    cattr_accessor :admin_user_class
    # @!attribute
    # @return [Symbol] the name of the current user method provided by Devise
    cattr_accessor :current_user_method
    # @return [Array<Symbol>] attributes to whitelist on the user (see {ExceptionHunter::UserAttributesCollector})
    cattr_accessor :user_attributes
    # @return [Numeric] number of days until an error is considered stale
    cattr_accessor :errors_stale_time, default: 45.days
    # @return [Array<Hash>] configured notifiers for the application (see {ExceptionHunter::Notifiers})
    cattr_accessor :notifiers, default: []
    cattr_accessor :sensitive_fields, default: []

    # Returns true if there's an admin user class configured to
    # authenticate against.
    #
    # @return Boolean
    def self.auth_enabled?
      admin_user_class.present? && admin_user_class.try(:underscore)
    end
  end
end
