class FailingJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    raise ArgumentError, "I'll keep failing and failing"
  end
end
