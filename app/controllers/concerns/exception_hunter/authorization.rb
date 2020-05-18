module ExceptionHunter
  module Authorization
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_admin_user_class
    end

    def authenticate_admin_user_class
      admin_user_class = ExceptionHunter::Config.admin_user_class.underscore
      send("authenticate_#{admin_user_class}!") if admin_user_class
    end
  end
end
