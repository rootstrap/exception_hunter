require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @errors = ErrorGroup.all
    end

    def show
      @pagy, errors = pagy(most_recent_errors, items: 1)
      @error = ErrorPresenter.new(errors.first)
    end

    private

    def error_groups
      ErrorGroup.all
    end

    def most_recent_errors
      Error.most_recent(params[:id])
    end
  end
end
