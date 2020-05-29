require 'sidekiq/web'

Rails.application.routes.draw do
  ExceptionHunter.routes(self)
  devise_for :users
  mount Sidekiq::Web => '/sidekiq'

  get :raising_endpoint, to: 'exception#raising_endpoint'
  post :broken_post, to: 'exception#broken_post'
  post :failing_job, to: 'exception#failing_job'
end
