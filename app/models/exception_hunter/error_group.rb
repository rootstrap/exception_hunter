module ExceptionHunter
  class ErrorGroup < ApplicationRecord
    SIMILARITY_THRESHOLD = 0.75

    validates :error_class_name, presence: true

    has_many :grouped_errors, class_name: 'ExceptionHunter::Error', dependent: :destroy

    scope :most_similar, lambda { |message|
      quoted_message = ActiveRecord::Base.connection.quote_string(message)
      where("similarity(exception_hunter_error_groups.message, :message) >= #{SIMILARITY_THRESHOLD}", message: message)
        .order(Arel.sql("similarity(exception_hunter_error_groups.message, '#{quoted_message}') DESC"))
    }

    scope :without_errors, -> {
      is_associated_error = Error[:error_group_id].eq(ErrorGroup[:id])
      where.not(Error.where(is_associated_error).arel.exists)
    }

    def self.find_matching_group(error)
      where(error_class_name: error.class_name)
        .most_similar(error.message.to_s)
        .first
    end

    def last_occurrence
      @last_occurrence ||= grouped_errors.maximum(:occurred_at)
    end

    def total_occurrences
      @total_occurrences ||= grouped_errors.count
    end
  end
end
