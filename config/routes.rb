ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[index show] do
    get 'resolve', on: :member, to: 'errors#resolve', as: :resolve
    delete 'purge', on: :collection, to: 'errors#destroy', as: :purge
  end
end
