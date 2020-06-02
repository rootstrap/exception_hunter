module ExceptionHunter
  module SessionsHelper
    def current_admin_user?
      underscored_admin_user_class &&
        current_admin_class_name(underscored_admin_user_class)
    end

    def underscored_admin_user_class
      ExceptionHunter::Config.admin_user_class.try(:underscore)
    end

    def current_admin_class_name(class_name)
      send("current_#{class_name.underscore}")
    end
  end
end
