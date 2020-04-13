class ExceptionController < ApplicationController
  def raising_endpoint
    raise ArgumentError, 'You should not have called me'
  end
end
