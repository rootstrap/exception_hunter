module ExceptionHunter
  class DataRedacter
    attr_reader :params, :params_to_filter

    def initialize(params, params_to_filter)
      @params = params
      @params_to_filter = params_to_filter
    end

    def redact
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
