Rails.application.routes.draw do
  devise_for :users
  ExceptionHunter.routes(self)

  get :raising_endpoint, to: 'exception#raising_endpoint'
  post :broken_post, to: 'exception#broken_post'
end
