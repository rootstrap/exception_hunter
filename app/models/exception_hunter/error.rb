module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :occurred_at, presence: true

    belongs_to :error_group, touch: true

    before_validation :set_occurred_at, on: :create
    after_create :unresolve_error_group, unless: -> { error_group.active? }

    scope :most_recent, lambda { |error_group_id|
      where(error_group_id: error_group_id).order(occurred_at: :desc)
    }
    scope :with_occurrences_before, lambda { |max_occurrence_date|
      where(Error[:occurred_at].lteq(max_occurrence_date))
    }
    scope :in_period, ->(period) { where(occurred_at: period) }
    scope :in_last_7_days, -> { in_period(7.days.ago.beginning_of_day..Time.now) }
    scope :in_current_month, lambda {
      in_period(Date.current.beginning_of_month.beginning_of_day..Date.current.end_of_month.end_of_day)
    }
    scope :from_active_error_groups, lambda {
      joins(:error_group).where(error_group: ErrorGroup.active)
    }
    scope :from_resolved_error_groups, lambda {
      joins(:error_group).where(error_group: ErrorGroup.resolved)
    }

    private

    def set_occurred_at
      self.occurred_at ||= Time.now
    end

    def unresolve_error_group
      error_group.active!
    end
  end
end
