require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  ExceptionHunter.routes(self)
  mount Sidekiq::Web => '/sidekiq'

  get :raising_endpoint, to: 'exception#raising_endpoint'
  post :failing_job, to: 'exception#failing_job'
end
