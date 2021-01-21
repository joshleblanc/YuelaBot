module Helpers
  module InjectMiddleware
    def inject_middleware(command)
      method = command.method(:command).to_proc
      middleware = GLOBAL_MIDDLEWARE.dup.map(&:new)
      if command.respond_to?(:middleware)
        middleware.push *command.middleware
      end
      method.define_singleton_method(:call) do |event, *args|
        begin
          transformed_args = args.dup
          middleware.each do |m|
            transformed_args = m.before(event, *transformed_args)
          end
          transformed_output = super(event, *transformed_args)
          middleware.each do |m|
            transformed_output = m.after(event, transformed_output, *transformed_args)
          end
          transformed_output
        rescue StandardError => e
          middleware.each do |m|
            m.after(event, "", *transformed_args)
          end
          raise e
        end
      end
      method
    end
  end
end