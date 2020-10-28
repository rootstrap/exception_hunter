module ExceptionHunter
  class DataRedacter
    class << self
      def redact(params, params_to_filter)
        return params if params.blank?

        parameter_filter = params_filter.new(params_to_filter)
        parameter_filter.filter(params)
      end

      private

      def params_filter
        if defined?(::ActiveSupport::ParameterFilter)
          ::ActiveSupport::ParameterFilter
        else
          ::ActionDispatch::Http::ParameterFilter
        end
      end
    end
  end
end
