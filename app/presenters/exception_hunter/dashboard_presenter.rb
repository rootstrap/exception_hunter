module ExceptionHunter
  class DashboardPresenter
    LAST_7_DAYS_TAB = 'last_7_days'.freeze
    CURRENT_MONTH_TAB = 'current_month'.freeze
    TOTAL_ERRORS_TAB = 'total_errors'.freeze
    RESOLVED_ERRORS_TAB = 'resolved'.freeze
    IGNORED_ERRORS_TAB = 'ignored'.freeze
    TABS = [LAST_7_DAYS_TAB, CURRENT_MONTH_TAB, TOTAL_ERRORS_TAB, RESOLVED_ERRORS_TAB, IGNORED_ERRORS_TAB].freeze
    DEFAULT_TAB = LAST_7_DAYS_TAB

    attr_reader :current_tab

    def initialize(current_tab)
      assign_tab(current_tab)
      calculate_tabs_counts
    end

    def tab_active?(tab)
      tab == current_tab
    end

    def partial_for_tab
      case current_tab
      when LAST_7_DAYS_TAB
        'exception_hunter/errors/last_7_days_errors_table'
      when CURRENT_MONTH_TAB, TOTAL_ERRORS_TAB, RESOLVED_ERRORS_TAB, IGNORED_ERRORS_TAB
        'exception_hunter/errors/errors_table'
      end
    end

    def errors_count(tab)
      @tabs_counts[tab]
    end

    private

    def assign_tab(tab)
      @current_tab = if TABS.include?(tab)
                       tab
                     else
                       DEFAULT_TAB
                     end
    end

    def calculate_tabs_counts
      active_errors = Error.from_active_error_groups
      @tabs_counts = {
        LAST_7_DAYS_TAB => active_errors.in_last_7_days.count,
        CURRENT_MONTH_TAB => active_errors.in_current_month.count,
        TOTAL_ERRORS_TAB => active_errors.count,
        RESOLVED_ERRORS_TAB => Error.from_resolved_error_groups.count,
        IGNORED_ERRORS_TAB => Error.from_ignored_error_groups.count
      }
    end
  end
end
