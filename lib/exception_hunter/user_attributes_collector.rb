module ExceptionHunter
  # Utility module used to whitelist the user's attributes.
  # Can be configured in {ExceptionHunter.setup ExceptionHunter.setup} to extract
  # custom attributes.
  #
  # @example
  #   ExceptionHunter.setup do |config|
  #     config.user_attributes = [:id, :email, :role, :active?]
  #   end
  #
  module UserAttributesCollector
    extend self

    # Gets the attributes configured for the user.
    #
    # @example
    #   UserAttributesCollector.collect_attributes(current_user)
    #   # => { id: 42, email: "example@user.com" }
    #
    # @param user instance in your application
    # @return [Hash] the whitelisted attributes from the user
    def collect_attributes(user)
      return {} unless user

      attributes.reduce({}) do |data, attribute|
        data.merge(attribute => user.try(attribute))
      end
    end

    private

    def attributes
      Config.user_attributes
    end
  end
end
