require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ErrorsController < ApplicationController
    def index
      @errors = error_groups
    end

    private

    def error_groups
      ErrorGroup.all
    end
  end
end
