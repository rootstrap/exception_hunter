module ExceptionHunter
  module UserAttributesCollector
    extend self

    def collect_attributes(user)
      user_data = {}
      attributes.each do |attribute|
        value = user.send(attribute)
        user_data[attribute] = value

      rescue NoMethodError => e
        logger.error e.message
      end

      user_data
    end

    def attributes
      attributes = Config.user_attributes

      raise 'User attributes are required to be an array' unless
        attributes.is_a?(Array)

      attributes
    end
  end
end
