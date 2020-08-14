module Helpers
  def inject_middleware(command)
    method = command.method(:command).to_proc
    middleware = GLOBAL_MIDDLEWARE.dup
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
        e.message
      end
    end
    method
  end
end