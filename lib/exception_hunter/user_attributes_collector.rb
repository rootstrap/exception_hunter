module ExceptionHunter
  module UserAttributesCollector
    extend self

    def collect_attributes(user)
      return unless user

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
