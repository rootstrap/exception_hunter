module ExceptionHunter
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    class << self
      delegate :[], to: :arel_table
    end
  end
end
