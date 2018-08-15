module Commands
    class NduggerCommand
        class << self
            def name
                [:ndugger]
            end

            def attributes
                {
                    description: 'Duggerfy a message',
                    usage: 'ndugger [message]'
                }
            end

            def command
                lambda do |event, *args|
                    message = args.join(' ')
                    message.downcase.chars.map { |c| rand > 0.5 ? c.upcase : c }.join
                end
            end
        end
    end
end