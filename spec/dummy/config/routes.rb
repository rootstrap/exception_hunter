Rails.application.routes.draw do
  mount ExceptionHunter::Engine, at: 'exception_hunter'
end
