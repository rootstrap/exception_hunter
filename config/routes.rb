ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[index show] do
    get 'resolve', on: :member, to: 'errors#resolve', as: :resolve
  end
end
