module Commands
    class JSCommand
        class << self
            include Discordrb::Webhooks

            def name
                [:js, :eval]
            end

            def attributes
                {
                    description: 'JS Eval',
                    usage: 'eval [code]'
                }
            end 

            def command
                lambda do |event, *args|
                    code = args.join(' ')

                    cxt = MiniRacer::Context.new timeout: 3000

                    begin
                        cxt.eval code
                    rescue StandardError => bang
                        bang
                    end
                end
            end
        end
    end
end