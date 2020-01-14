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
      
      def login(user_id, email, pass, meta)
        SoChat.login(email, pass, meta)
        cookie = SoChatCookie.find_by(email: email, url: SoChat.base_url(!!meta))
        cookie.user = User.find_or_create_by(id: user_id) do |u|
          u.name = event.author.name
        end
        cookie.save
      end

      def command(event, *args)
        return if event.from_bot?
        event.author.pm("Emails and passwords are not saved.")
        event.author.pm("Enter your email:")
        email = event.author.await!(timeout: 60)
        if email
          event.author.pm("Enter your password:")
          password = event.author.await!(timeout: 60)
              if password
            begin
              login(event.author.id, email.message.content, password.message.content, false)
              login(event.author.id, email.message.content, password.message.content, true)
              event.author.pm "Logged in"
            rescue StandardError => e
              p e.message
              event.author.pm "Login failed"
            end
          end
        end
      end
    end
  end
end
