require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @errors = ErrorGroup.all.order(created_at: :desc)
      @errors_count = Error.count
      @month_errors = Error.in_current_month.count
    end

    def show
      @pagy, errors = pagy(most_recent_errors, items: 1)
      @error = ErrorPresenter.new(errors.first)
    end

    private

    def most_recent_errors
      Error.most_recent(params[:id])
    end
  end
end
