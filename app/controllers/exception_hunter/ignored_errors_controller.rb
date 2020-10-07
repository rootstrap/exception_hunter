require_dependency 'exception_hunter/application_controller'

module ExceptionHunter
  class IgnoredErrorsController < ApplicationController
    before_action :set_error_group, only: %i[create reopen]

    def create
      @error_group.ignored!
      redirect_to errors_path, notice: 'Error ignored successfully'
    end

    def reopen
      @error_group.active!
      redirect_to errors_path, notice: 'Error re-opened successfully'
    end

    private

    def set_error_group
      @error_group = ErrorGroup.find(params.dig(:error_group, :id))
    end

    def error_group_params
      params.require(:error_group).permit(:id)
    end
  end
end
