module ExceptionHunter
  class ApplicationController < ActionController::Base
    include ExceptionHunter::Authorization

    protect_from_forgery with: :exception
  end
end
