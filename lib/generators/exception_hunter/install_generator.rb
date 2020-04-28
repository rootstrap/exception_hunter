require 'rails/generators/active_record'

module ExceptionHunter
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc 'Installs Exception Hunter'

      source_root File.expand_path('templates', __dir__)

      def copy_initializer
        template 'exception_hunter.rb.erb', 'config/initializers/exception_hunter.rb'
      end
    end
  end
end
