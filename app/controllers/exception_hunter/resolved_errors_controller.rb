require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ResolvedErrorsController < ApplicationController
    def create
      ErrorGroup.find(params[:error_group][:id]).resolved!

      redirect_to errors_path, notice: 'Error resolved successfully'
    end
  end
end
