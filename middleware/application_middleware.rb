module Middleware
  class ApplicationMiddleware
    def before(event, *args)
      args
    end

    def after(event, output, *args)
      output
    end
  end
end