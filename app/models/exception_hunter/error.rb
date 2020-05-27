module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :occurred_at, presence: true

    belongs_to :error_group, touch: true

    before_validation :set_occurred_at, on: :create

    scope :most_recent, lambda { |error_group_id|
      where(error_group_id: error_group_id).order(occurred_at: :desc)
    }

    scope :with_occurrences_before, lambda { |max_occurrence_date|
      where(Error[:occurred_at].lteq(max_occurrence_date))
    }

    def self.in_current_month
      current_month = Date.today.beginning_of_month..Date.today.end_of_month

      where(occurred_at: current_month)
    end

    private

    def set_occurred_at
      self.occurred_at ||= Time.now
    end
  end
end
