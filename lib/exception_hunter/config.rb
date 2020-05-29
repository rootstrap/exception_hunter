module ExceptionHunter
  class Config
    cattr_accessor :admin_user_class,
                   :current_user_method, :user_attributes
    cattr_accessor :enabled, default: true
    cattr_accessor :errors_stale_time, default: 45.days
  end
end
