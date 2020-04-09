Rails.application.routes.draw do
  mount ExceptionHunter::Engine, at: 'exception_hunter'

  get :test, to: 'exception#operation_that_raises'
end
