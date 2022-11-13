module Commands
  class AfkCommand < Discordrb::Ext::Command
    cmd :afk
  
    min_args 0
    usage "afk [message?]"
    description "Set yourself as afk"
    
    call ->(e, *message) do 
      begin
        user_id = e.author.id
        user = User.find_or_create_by(id: user_id) do |u|
          u.name = e.author.name
        end
        user.afk.destroy if user.afk
        Afk.create(message: (message.join(' ') unless message.empty?), user: user)

        e.user.await(:"back_#{user_id}") do |back_event|
          p "Removing afk for #{back_event.author}"
          User.find(back_event.author.id).afk.destroy
        end
        nil
      rescue StandardError => e
        e
      end
    end
  end
end
