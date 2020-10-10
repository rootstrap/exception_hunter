module ExceptionHunter
  # Class in charge of disposing of stale errors as specified in the {ExceptionHunter::Config}.
  class ErrorReaper
    class << self
      # Destroys all stale errors.
      #
      # @example
      #   ErrorReaper.purge(stale_time: 30.days)
      #
      # @param [Numeric] stale_time considered when destroying errors
      # @return [void]
      def purge(stale_time: Config.errors_stale_time)
        ActiveRecord::Base.transaction do
          Error.with_occurrences_before(Date.today - stale_time).destroy_all
          ErrorGroup.without_errors.destroy_all
        end
      end
    end
  end
end
