module ExceptionHunter
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    class << self
      delegate :[], to: :arel_table

      def sql_similarity(attr, value)
        Arel::Nodes::NamedFunction.new('similarity', [attr, Arel::Nodes.build_quoted(value)])
      end
    end
  end
end
