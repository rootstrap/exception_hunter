Rails.application.routes.draw do
  devise_for :users
  ExceptionHunter.routes(self)

  get :raising_endpoint, to: 'exception#raising_endpoint'
end
