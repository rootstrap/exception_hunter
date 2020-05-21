module ExceptionHunter
  class Config
    cattr_accessor :enabled, default: true
    cattr_accessor :current_user_method, :user_attributes
  end
end
