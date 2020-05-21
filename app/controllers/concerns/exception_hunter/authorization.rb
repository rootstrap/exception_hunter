module ExceptionHunter
  module Authorization
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_admin_user_class
    end

    def authenticate_admin_user_class
      admin_user_class = underscored_admin_user_class
      return if admin_user_class.nil? ||
                (admin_user_class && send("authenticate_#{admin_user_class}!"))

      redirect_to_login
    end

    def redirect_to_login
      render 'exception_hunter/devise/sessions/new'
    end

    def underscored_admin_user_class
      ExceptionHunter::Config.admin_user_class.try(:underscore)
    end
  end
end
