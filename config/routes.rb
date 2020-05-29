ExceptionHunter::Engine.routes.draw do
  resources :errors, only: %i[show]
  get '/', to: 'errors#index', as: :exception_hunter_dashboard

  admin_user_class = ExceptionHunter::Config.admin_user_class
  if admin_user_class.try(:underscore)
    devise_scope admin_user_class.underscore.to_sym do
      get '/login', to: 'devise/sessions#new', as: :exception_hunter_login
      post '/login', to: 'devise/sessions#create', as: :exception_hunter_create_session
      get '/logout', to: 'devise/sessions#destroy', as: :exception_hunter_logout
    end

    devise_for admin_user_class.underscore.to_sym, only: []
  end
end
