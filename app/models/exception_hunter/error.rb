module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :occurred_at, presence: true

    belongs_to :error_group

    before_validation :set_occurred_at, on: :create
    after_create :update_error_group

    scope :most_recent, lambda { |error_group_id|
      where(error_group_id: error_group_id).order(occurred_at: :desc)
    }

    def self.in_current_month
      current_month = Date.today.beginning_of_month..Date.today.end_of_month

      where(occurred_at: current_month)
    end

    private

    def set_occurred_at
      self.occurred_at ||= Time.now
    end

    def update_error_group
      error_group.touch
    end
  end
end
