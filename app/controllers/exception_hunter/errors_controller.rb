require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    include Pagy::Backend

    def index
      @errors = ErrorGroup.all
    end

    def show
      @pagy, errors = pagy(last_error, items: 1)
      @error = ErrorPresenter.new(errors.first)
    end

    private

    def last_error
      ErrorGroup.find(params[:id]).grouped_errors.order('created_at DESC')
    end
  end
end
