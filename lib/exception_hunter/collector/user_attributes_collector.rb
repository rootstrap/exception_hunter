module ExceptionHunter
  module UserAttributesCollector
    extend self

    def collect_attributes(user)
      attributes.reduce({}) do |data, attribute|
        data.merge(attribute => user.try(attribute))
      end
    end

    def attributes
      Config.user_attributes
    end
  end
end
