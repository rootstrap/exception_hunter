ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[index show] do
    delete 'purge', on: :collection, to: 'errors#destroy', as: :purge
  end

  resources :resolved_errors, only: %i[create]
end
