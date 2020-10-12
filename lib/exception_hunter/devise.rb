module ExceptionHunter
  module Devise
    # Used so we can integrate with {https://github.com/heartcombo/devise Devise} and
    # provide a custom login on the dashboard.
    class SessionsController < ::Devise::SessionsController
      skip_before_action :verify_authenticity_token

      layout 'exception_hunter/exception_hunter_logged_out'

      def after_sign_out_path_for(*)
        '/exception_hunter/login'
      end

      def after_sign_in_path_for(*)
        '/exception_hunter'
      end
    end
  end
end
