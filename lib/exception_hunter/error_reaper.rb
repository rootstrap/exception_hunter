module ExceptionHunter
  class ErrorReaper
    class << self
      def purge(stale_time: Config.errors_stale_time)
        ActiveRecord::Base.transaction do
          Error.with_occurrences_before(Date.today - stale_time).destroy_all
          ErrorGroup.without_errors.destroy_all
        end
      end
    end
  end
end
