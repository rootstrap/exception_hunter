module ExceptionHunter
  module ErrorsHelper
    def format_tracked_data(tracked_data)
      JSON.pretty_generate(tracked_data)
    end
  end
end
