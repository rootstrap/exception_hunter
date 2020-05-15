Rails.application.routes.draw do
  devise_for :admin_users, ExceptionHunter::Devise.config
  ExceptionHunter.routes(self)
  devise_for :users

  get :raising_endpoint, to: 'exception#raising_endpoint'
end
