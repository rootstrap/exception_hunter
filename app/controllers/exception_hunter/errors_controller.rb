require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    def index
      @errors = ErrorGroup.all
      @errors_count = Error.count
      @month_errors = Error.in_current_month.count
    end
  end
end
