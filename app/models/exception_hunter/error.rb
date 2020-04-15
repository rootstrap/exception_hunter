module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :occurred_at, presence: true

    belongs_to :error_group

    before_validation :set_occurred_at, on: :create

    private

    def set_occurred_at
      self.occurred_at ||= Time.now
    end
  end
end
