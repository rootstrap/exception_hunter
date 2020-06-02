ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[index show] do
    delete 'purge', on: :collection, to: 'errors#destroy', as: :purge
  end

  resources :resolved_errors, only: %i[create]

  get '/', to: redirect('/exception_hunter/errors')

  if ExceptionHunter::Config.auth_enabled?
    admin_user_class = ExceptionHunter::Config.admin_user_class.underscore.to_sym

    devise_scope admin_user_class do
      get '/login', to: 'devise/sessions#new', as: :exception_hunter_login
      post '/login', to: 'devise/sessions#create', as: :exception_hunter_create_session
      get '/logout', to: 'devise/sessions#destroy', as: :exception_hunter_logout
    end

    devise_for admin_user_class, only: []
  end
end
