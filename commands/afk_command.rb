module Commands
  class AfkCommand
    class << self
      def name
        :afk
      end

      def attributes
        {
          min_args: 0,
          usage: 'afk [message?]',
          description: 'Set yourself as afk'
        }
      end

      def command
        lambda do |e, *message|
          begin
            user_id = e.author.id
            user = User.first_or_new({ id: user_id })
            user.name = e.author.name
            user.save
            user.afk.destroy if user.afk
            Afk.create(message: (message.join(' ') unless message.empty?), user: user)

            e.user.await(:back) do |back_event|
              p "Removing afk for #{back_event.author}"
              user = User.get(back_event.author.id)
              if user.afk.destroy
                p "#{user.name} is back"
              else
                user.errors.full_messages
              end
            end
            nil
          rescue StandardError => e
            e
          end
        end
      end
    end
  end
end