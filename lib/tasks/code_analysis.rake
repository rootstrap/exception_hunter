desc 'code analysis'
task :code_analysis do
  sh 'bundle exec rubocop app config lib spec'
  sh 'bundle exec reek app config lib'
  sh 'bundle exec rails_best_practices .'
end
