ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[show]
  get '/', to: 'errors#index', as: :dashboard
end
