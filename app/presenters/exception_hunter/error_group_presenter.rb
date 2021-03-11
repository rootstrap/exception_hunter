module ExceptionHunter
  class ErrorGroupPresenter
    delegate_missing_to :error_group

    def initialize(error_group)
      @error_group = error_group
    end

    def self.wrap_collection(collection)
      collection.map { |error_group| new(error_group) }
    end

    def self.format_occurrence_day(day)
      date = day.to_date
      date == Date.yesterday ? 'Yesterday' : date.strftime('%A, %B %d')
    end

    def show_for_day?(day)
      last_occurrence.in_time_zone.to_date == day.to_date
    end

    private

    attr_reader :error_group
  end
end
