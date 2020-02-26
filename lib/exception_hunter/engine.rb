module ExceptionHunter
  class Engine < ::Rails::Engine
    isolate_namespace ExceptionHunter
  end
end
