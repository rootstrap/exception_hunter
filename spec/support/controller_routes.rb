module ControllerRoutes
  extend ActiveSupport::Concern

  included do
    routes { ::ExceptionHunter::Engine.routes }
  end
end
