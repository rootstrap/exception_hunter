module ExceptionHunter
  class ErrorReaper
    DELETE_UNTIL = 1.month.ago

    class << self
      def purge(delete_until: DELETE_UNTIL)
        ActiveRecord::Base.transaction do
          Error.with_occurrences_before(delete_until).destroy_all
          ErrorGroup.without_errors.destroy_all
        end
      end
    end
  end
end
