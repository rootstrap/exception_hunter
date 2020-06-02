module ExceptionHunter
  module Devise
    class SessionsController < ::Devise::SessionsController
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
