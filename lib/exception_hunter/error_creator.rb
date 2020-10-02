module ExceptionHunter
  class ErrorCreator
    HTTP_TAG = 'HTTP'.freeze
    WORKER_TAG = 'Worker'.freeze
    MANUAL_TAG = 'Manual'.freeze

    class << self
      def call(tag: nil, **error_attrs)
        return unless should_create?

        ActiveRecord::Base.transaction do
          error_attrs = extract_user_data(error_attrs)
          error = ::ExceptionHunter::Error.new(error_attrs)
          error_group = ::ExceptionHunter::ErrorGroup.find_matching_group(error) || ::ExceptionHunter::ErrorGroup.new
          update_error_group(error_group, error, tag)
          error.error_group = error_group
          error.save!
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
        error_attrs[:user_data] =
          if user.nil?
            {}
          else
            UserAttributesCollector.collect_attributes(user)
          end

        error_attrs.delete(:user)
        error_attrs
      end

      def notify(error)
        ExceptionHunter::Config.notifiers.each do |notifier|
          slack_notifier = ExceptionHunter::Notifiers::SlackNotifier.new(error, notifier)
          serializer = ExceptionHunter::Notifiers::Serializers::SlackNotifierSerializer
          serialized_slack_notifier = serializer.serialize(slack_notifier)
          ExceptionHunter::SendNotificationJob.perform_later(serialized_slack_notifier)
        end
      end
    end
  end
end
