module ExceptionHunter
  module Authorization
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_admin_user_class
    end

    def authenticate_admin_user_class
      return unless ExceptionHunter::Config.auth_enabled? && !send("current_#{underscored_admin_user_class}")

      redirect_to '/exception_hunter/login'
    end

    def redirect_to_login
      render 'exception_hunter/devise/sessions/new'
    end

    def underscored_admin_user_class
      ExceptionHunter::Config.admin_user_class.underscore
    end
  end
end
