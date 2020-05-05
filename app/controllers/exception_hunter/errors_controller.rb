require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @errors = error_groups
    end

    def show
      Pagy::VARS[:items] = 1
      @pagy, @error = pagy(last_error)
    end

    private

    def error_groups
      ErrorGroup.all
    end

    def last_error
      ErrorGroup.find(params[:id]).grouped_errors.order('created_at DESC')
    end
  end
end
