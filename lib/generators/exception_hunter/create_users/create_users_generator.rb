module ExceptionHunter
  class CreateUsersGenerator < Rails::Generators::NamedBase
    argument :name, type: :string, default: 'AdminUser'

    def install_devise
      begin
        require 'devise'
      rescue LoadError
        log :error, 'Please install devise and require add it to your gemfile or run with --skip-users'
        exit(false)
      end

      initializer_file =
        File.join(destination_root, 'config', 'initializers', 'devise.rb')

      if File.exist?(initializer_file)
        log :generate, 'No need to install devise, already done.'
      else
        log :generate, 'devise:install'
        invoke 'devise:install'
      end
    end

    def create_admin_user
      invoke 'devise', [name]
    end

    def remove_registerable_from_model
      return if options[:registerable]

      model_file = File.join(destination_root, 'app', 'models', "#{file_path}.rb")
      gsub_file model_file, /\:registerable([.]*,)?/, ''
    end
  end
end
