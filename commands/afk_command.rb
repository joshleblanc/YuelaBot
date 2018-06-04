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
            p user_id
            user = User.first_or_new({ id: user_id })
            user.name = e.author.name
            user.save
            user.afk.destroy if user.afk
            afk = Afk.create(message: (message.join(' ') unless message.empty?), user: user)

            e.user.await(:back) do |_|
              afk.destroy
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