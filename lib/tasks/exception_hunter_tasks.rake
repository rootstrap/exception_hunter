namespace :exception_hunter do
  desc 'Purges old errors'
  task purge_errors: [:environment] do
    ::ExceptionHunter::ErrorReaper.purge
  end
end
