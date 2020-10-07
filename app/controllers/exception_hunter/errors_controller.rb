require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @dashboard = DashboardPresenter.new(current_tab)
      shown_errors = errors_for_tab(@dashboard).order(updated_at: :desc).distinct
      @errors = ErrorGroupPresenter.wrap_collection(shown_errors)
    end

    def show
      @pagy, errors = pagy(most_recent_errors, items: 1)
      @error = ErrorPresenter.new(errors.first!)
    end

    def destroy
      ErrorReaper.purge

      redirect_back fallback_location: errors_path, notice: 'Errors purged successfully'
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
        ErrorGroup.with_errors_in_last_7_days.active
      when DashboardPresenter::CURRENT_MONTH_TAB
        ErrorGroup.with_errors_in_current_month.active
      when DashboardPresenter::TOTAL_ERRORS_TAB
        ErrorGroup.active
      when DashboardPresenter::RESOLVED_ERRORS_TAB
        ErrorGroup.resolved
      when DashboardPresenter::IGNORED_ERRORS_TAB
        ErrorGroup.ignored
      end
    end
  end
end
