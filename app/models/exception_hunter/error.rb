module ExceptionHunter
  class Error < ApplicationRecord
    serialize :backtrace, Array

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :ocurred_at, presence: true
  end
end
