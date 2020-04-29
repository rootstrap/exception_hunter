ExceptionHunter::Engine.routes.draw do
  resources :errors, only: [:index, :show]
end
