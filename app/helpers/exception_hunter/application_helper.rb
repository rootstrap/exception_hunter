module ExceptionHunter
  module ApplicationHelper
    include Pagy::Frontend

    def application_name
      if defined? Rails.application.class.module_parent_name
        Rails.application.class.module_parent_name
      else
        Rails.application.class.parent_name
      end
    end
  end
end
