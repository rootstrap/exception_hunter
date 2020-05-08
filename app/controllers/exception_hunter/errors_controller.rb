require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @errors = error_groups
    end

    def show
      Pagy::VARS[:items] = 1
      @pagy, @error = pagy(most_recent_errors)
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
