module ExceptionHunter
  class ErrorCreator
    class << self
      def call(**error_attrs)
        ActiveRecord::Base.transaction do
          error_attrs = extract_user_data(error_attrs)
          error = Error.new(error_attrs)
          error_group = ErrorGroup.find_matching_group(error) || ErrorGroup.new
          update_error_group(error_group, error)
          error.error_group = error_group
          error.save!
          error
        end
      rescue ActiveRecord::RecordInvalid
        false
      end

      private

      def update_error_group(error_group, error)
        error_group.error_class_name = error.class_name
        error_group.message = error.message

        error_group.save!
      end

      def extract_user_data(**error_attrs)
        user = error_attrs[:user]
        error_attrs[:user_data] =
          if user.nil?
            {}
          else
            UserAttributesCollector.collect_attributes(user)
          end

        error_attrs.delete(:user)
        error_attrs
      end
    end
  end
end
