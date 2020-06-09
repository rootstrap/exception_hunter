module ExceptionHunter
  class ErrorPresenter
    delegate_missing_to :error
    delegate :tags, to: :error_group

    BacktraceLine = Struct.new(:path, :file_name, :line_number, :method_call)

    def initialize(error)
      @error = error
    end

    def backtrace
      error.backtrace.map do |line|
        format_backtrace_line(line)
      end
    end

    def environment_data
      error.environment_data.except('params')
    end

    def tracked_params
      (error.environment_data || {})['params']
    end

    private

    attr_reader :error

    def format_backtrace_line(line)
      matches = line.match(%r{(?<path>.*)/(?<file_name>[^:]*):(?<line_number>\d*).*`(?<method_call>.*)'})

      if matches.nil?
        line
      else
        BacktraceLine.new(matches[:path],
                          matches[:file_name],
                          matches[:line_number],
                          matches[:method_call])
      end
    end
  end
end
