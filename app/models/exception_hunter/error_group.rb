module ExceptionHunter
  class ErrorGroup < ApplicationRecord
    SIMILARITY_THRESHOLD = 0.75

    validates :error_class_name, presence: true

    has_many :grouped_errors, class_name: 'ExceptionHunter::Error', dependent: :destroy

    enum status: { active: 0, resolved: 1 }

    scope :most_similar, lambda { |message|
      message_similarity = sql_similarity(ErrorGroup[:message], message)
      where(message_similarity.gteq(SIMILARITY_THRESHOLD))
        .order(message_similarity.desc)
    }

    scope :without_errors, lambda {
      is_associated_error = Error[:error_group_id].eq(ErrorGroup[:id])
      where.not(Error.where(is_associated_error).arel.exists)
    }
    scope :with_errors_in_last_7_days, lambda {
      joins(:grouped_errors)
        .where(Error.in_last_7_days.where(Error[:error_group_id].eq(ErrorGroup[:id])).arel.exists)
    }
    scope :with_errors_in_current_month, lambda {
      joins(:grouped_errors)
        .where(Error.in_current_month.where(Error[:error_group_id].eq(ErrorGroup[:id])).arel.exists)
    }

    def self.find_matching_group(error)
      where(error_class_name: error.class_name)
        .most_similar(error.message.to_s)
        .first
    end

    def first_occurrence
      @first_occurrence ||= grouped_errors.minimum(:occurred_at)
    end

    def last_occurrence
      @last_occurrence ||= grouped_errors.maximum(:occurred_at)
    end

    def total_occurrences
      @total_occurrences ||= grouped_errors.count
    end
  end
end
