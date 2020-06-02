require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class ResolvedErrorsController < ApplicationController
    def create
      ErrorGroup.find(resolved_error_params[:id]).resolved!

      redirect_to errors_path, notice: 'Error resolved successfully'
    end

    def resolved_error_params
      params.require(:error_group).permit(:id)
    end
  end
end
