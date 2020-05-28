module ExceptionHunter
  module Authorization
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_admin_user_class
    end

    def authenticate_admin_user_class
      send(admin_authentication_method) if underscored_admin_user_class
    end

    def redirect_to_login
      render 'exception_hunter/devise/sessions/new'
    end

    def underscored_admin_user_class
      ExceptionHunter::Config.admin_user_class.try(:underscore)
    end

    def admin_authentication_method
      ExceptionHunter::Config.admin_authentication_method
    end
  end
end
