module ExceptionHunter
  class Config
    cattr_accessor :admin_user_class, :admin_authentication_method,
                   :current_user_method, :user_attributes
  end
end
