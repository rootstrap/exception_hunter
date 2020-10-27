module ExceptionHunter
  # Core class in charge of the actual persistence of errors and notifications.
  class ErrorCreator
    HTTP_TAG = 'HTTP'.freeze
    WORKER_TAG = 'Worker'.freeze
    MANUAL_TAG = 'Manual'.freeze

    class << self
      # Creates an error with the given attributes and persists it to
      # the database.
      #
      # @param [HTTP_TAG, WORKER_TAG, MANUAL_TAG] tag to append to the error if any
      # @return [ExceptionHunter::Error, false] the error or false if it was not possible to create it
      def call(tag: nil, **error_attrs)
        return unless should_create?

        ActiveRecord::Base.transaction do
          error_attrs = extract_user_data(error_attrs)
          hide_sensitive_values(error_attrs)
          error = ::ExceptionHunter::Error.new(error_attrs)
          error_group = ::ExceptionHunter::ErrorGroup.find_matching_group(error) || ::ExceptionHunter::ErrorGroup.new
          update_error_group(error_group, error, tag)
          error.error_group = error_group
          error.save!
          return if error_group.ignored?

          notify(error)
          error
        end
      rescue ActiveRecord::RecordInvalid
        false
      end

      private

      def should_create?
        Config.enabled
      end

      def update_error_group(error_group, error, tag)
        error_group.error_class_name = error.class_name
        error_group.message = error.message
        error_group.tags << tag unless tag.nil?
        error_group.tags.uniq!

        error_group.save!
      end

      def extract_user_data(**error_attrs)
        user = error_attrs[:user]
        error_attrs[:user_data] = UserAttributesCollector.collect_attributes(user)

        error_attrs.delete(:user)
        error_attrs
      end

      def notify(error)
        ExceptionHunter::Config.notifiers.each do |notifier|
          slack_notifier = ExceptionHunter::Notifiers::SlackNotifier.new(error, notifier)
          serializer = ExceptionHunter::Notifiers::SlackNotifierSerializer
          serialized_slack_notifier = serializer.serialize(slack_notifier)
          ExceptionHunter::SendNotificationJob.perform_later(serialized_slack_notifier)
        end
      end

      def hide_sensitive_values(error_attrs)
        values_to_hide = ExceptionHunter::Config.values_to_hide
        return if values_to_hide.blank?

        error_attrs.each_key do |key|
          if values_to_hide.include?(key)
            error_attrs[key] = '*********'
          elsif values_to_hide.map(&:to_s).include?(key.to_s)
            error_attrs[key.to_s] = '*********'
          elsif error_attrs[key].is_a?(Hash)
            hide_sensitive_values(error_attrs[key])
          end
        end
      end
    end
  end
end
