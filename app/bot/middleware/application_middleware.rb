module Middleware
  class ApplicationMiddleware
    def before(event, *args)
      args
    end

    def after(event, output, *args)
      output
    end

    def cleanup
      # This should be implemented if you have any threads to cleanup
    end
  end
end