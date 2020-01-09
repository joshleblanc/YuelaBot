class CreateSoChatCookies < ActiveRecord::Migration[5.2]
  def change
    create_table(:so_chat_cookies) do |t|
      t.string :email
      t.string :cookie
      t.string :url
    end
  end
end
