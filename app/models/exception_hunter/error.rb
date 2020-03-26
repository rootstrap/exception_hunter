module ExceptionHunter
  class Error < ApplicationRecord
    validates :class_name, presence: true
    validates :ocurred_at, presence: true

    before_validation :set_ocurred_at, on: :create

    private

    def set_ocurred_at
      self.ocurred_at ||= Time.now
    end
  end
end
