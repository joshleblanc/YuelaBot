module Commands
    class RemindMeCommand
      class << self
        def name
          [:rm, :remind]
        end

        def regex
          /(\d+)(s|m|h)?/
        end
  
        def attributes
          {
            usage: 'remind [time] [message]',
            min_args: 2,
            description: 'Reminds the user after an allocated time has passed',
            contains: self.regex
          }
        end
  
        def command
          lambda do |event, time, *args|
            message = args.join(' ')

            match_data = time.match(self.regex)

            time = match_data[0].to_i

            if match_data[1] then
              if match_data[1] == 's' then
                length = time
              elsif match_data[1] == 'm' then
                length = time * 60
              elsif match_data[1] == 'h' then
                length = time * 3600
              end
            end

            Thread.abort_on_exception = true
            begin
              t = Thread.new {
                sleep time
                event << message
                t.kill if t.alive? 
              }
            rescue Exception => e
              event << e.inspect
            end
          end
        end
      end
    end
  end