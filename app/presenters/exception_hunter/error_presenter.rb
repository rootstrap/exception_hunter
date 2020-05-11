module ExceptionHunter
  class ErrorPresenter
    delegate_missing_to :error

    BacktraceLine = Struct.new(:path, :file_name, :line_number, :method_call)

    def initialize(error)
      @error = error
    end

    def backtrace
      error.backtrace.map do |line|
        format_backtrace_line(line)
      end
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
