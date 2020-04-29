ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[index show]
end
