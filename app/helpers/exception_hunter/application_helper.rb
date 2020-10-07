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

    def display_action_button(title, error)
      button_to(title.to_s, route_for_button(title, error),
                class: "button button-outline #{title}-button",
                data: { confirm: "Are you sure you want to #{title} this error?" }).to_s
    end

    def route_for_button(title, error)
      if title.eql?('ignore')
        ignored_errors_path(error_group: { id: error.id })
      else
        resolved_errors_path(error_group: { id: error.id })
      end
    end
  end
end
