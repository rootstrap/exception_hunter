class ExceptionController < ApplicationController
  skip_before_action :verify_authenticity_token

  def raising_endpoint
    raise ArgumentError, 'You should not have called me'
  end

  def failing_job
    FailingJob.perform_later(params.to_unsafe_hash)
  end
end
