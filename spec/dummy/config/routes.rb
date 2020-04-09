Rails.application.routes.draw do
  mount ExceptionHunter::Engine, at: 'exception_hunter'

  get :raising_endpoint, to: 'exception#raising_endpoint'
end
