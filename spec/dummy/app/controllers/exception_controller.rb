class ExceptionController < ApplicationController
  def operation_that_raises
    raise HunterTestException
  end
end
