require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @dashboard = DashboardPresenter.new(current_tab)
      @errors = ErrorGroupPresenter.wrap_collection(errors_for_tab(@dashboard).order(updated_at: :desc))
    end

    def show
      @pagy, errors = pagy(most_recent_errors, items: 1)
      @error = ErrorPresenter.new(errors.first)
    end

    private

    def most_recent_errors
      Error.most_recent(params[:id])
    end

    def current_tab
      params[:tab]
    end

    def errors_for_tab(dashboard)
      case dashboard.current_tab
      when DashboardPresenter::LAST_7_DAYS_TAB
        ErrorGroup.with_errors_in_last_7_days
      when DashboardPresenter::CURRENT_MONTH_TAB
        ErrorGroup.with_errors_in_current_month
      when DashboardPresenter::TOTAL_ERRORS_TAB
        ErrorGroup.all
      when DashboardPresenter::RESOLVED_ERRORS_TAB
        ErrorGroup.none
      end
    end
  end
end
