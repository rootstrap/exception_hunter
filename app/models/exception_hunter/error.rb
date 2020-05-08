module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :occurred_at, presence: true

    belongs_to :error_group

    before_validation :set_occurred_at, on: :create

    scope :most_recent, lambda { |error_group_id|
      where(error_group_id: error_group_id).order(occurred_at: :desc)
    }

    private

    def set_occurred_at
      self.occurred_at ||= Time.now
    end
  end
end
