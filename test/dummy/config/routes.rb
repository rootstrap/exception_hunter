Rails.application.routes.draw do
  mount ExceptionHunter::Engine => "/exception_hunter"
end
