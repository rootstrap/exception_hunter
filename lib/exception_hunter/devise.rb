module ExceptionHunter
  module Devise
    def self.config
      {
        path: '/exception_hunter',
        controllers: ExceptionHunter::Devise.controllers,
        as: :exception_hunter,
        path_names: { sign_in: 'login', sign_out: 'logout' },
        sign_out_via: [*::Devise.sign_out_via, :get].uniq
      }
    end

    def self.controllers
      {
        sessions: 'exception_hunter/devise/sessions'
      }
    end

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
