module Commands
  class SoLoginCommand
    class << self
      def name
        :so_login
      end

      def attributes
        {
          description: "Login to stackoverflow chat",
          usage: "so_login",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?
        meta = args[0]
        event.author.pm("Emails and passwords are not saved.")
        event.author.pm("Enter your email:")
        email = event.author.await!(timeout: 60)
        if email
          event.author.pm("Enter your password:")
          password = event.author.await!(timeout: 60)
              if password
            begin
              SoChat.login(email.message.content, password.message.content, meta)
              cookie = SoChatCookie.find_by(email: email.message.content, url: SoChat.base_url(!!meta))
              cookie.user = User.find_or_create_by(id: event.author.id) do |u|
                u.name = event.author.name
              end
              cookie.save
              event.author.pm "Logged in"
            rescue StandardError => e
              event.author.pm "Login failed"
            end
          end
        end
      end
    end
  end
end
