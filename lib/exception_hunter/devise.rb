require 'devise' if defined?(Devise)

module ExceptionHunter
  module Devise
    def self.config
      {
        path: '/exception_hunter',
        controllers: ExceptionHunter::Devise.controllers,
        path_names: { sign_in: 'login', sign_out: 'logout' }
      }
    end

    def self.controllers
      {
        sessions: 'exception_hunter/devise/sessions'
      }
    end

    class SessionsController < ::Devise::SessionsController
    end
  end
end
