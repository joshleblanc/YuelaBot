module Commands
    class TellCommand
      class << self
        def name
          [:tell, :t]
        end
  
        def attributes
          {
            min_args: 2,
            description: 'Pings a user with the specified command',
            usage: 'tell <user> <command> <...args?>'
          }
        end
  
        def command
          lambda do |event, user, command, *args|
            target_user = event.channel.users.find{ |u| u.username.match(/#{user}/i) }
            if target_user
              executed_command = BOT.simple_execute("#{command} #{args.join(' ')}", event)
              if executed_command
                event.respond "<@#{target_user.id}> #{executed_command}"
              end
            end
          end
        end
      end
    end
  end