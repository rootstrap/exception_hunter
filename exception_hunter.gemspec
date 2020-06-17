$LOAD_PATH .push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'exception_hunter/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'exception_hunter'
  spec.version     = ExceptionHunter::VERSION
  spec.authors     = ['Bruno Vezoli', 'Tiziana Romani']
  spec.email       = ['bruno.vezoli@rootstrap.com']
  spec.summary     = 'Exception tracking engine'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/rootstrap/exception_hunter'

  spec.required_ruby_version = '>= 2.5.5'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'pagy', '~> 3'

  spec.add_development_dependency 'brakeman', '~> 4.8'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rails_best_practices', '~> 1.20'
  spec.add_development_dependency 'reek', '~> 5.6'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
end
