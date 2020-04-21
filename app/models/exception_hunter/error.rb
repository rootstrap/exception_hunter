module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :occurred_at, presence: true

    belongs_to :error_group

    before_validation :set_occurred_at, on: :create

    def add_user(user)
      self.user_data = UserAttributesCollector.collect_attributes(user)
      save!
    end

    private

    def set_occurred_at
      self.occurred_at ||= Time.now
    end
  end
end
