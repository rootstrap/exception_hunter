require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class IgnoredErrorsController < ApplicationController
    def create
      error_group.ignored!
      redirect_to errors_path, notice: 'Error ignored successfully'
    end

    def reopen
      error_group.active!
      redirect_to errors_path, notice: 'Error re-opened successfully'
    end

    private

    def error_group
      @error_group ||= ErrorGroup.find(error_group_params[:id])
    end

    def error_group_params
      params.require(:error_group).permit(:id)
    end
  end
end
