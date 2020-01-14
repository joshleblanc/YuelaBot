class AddUserIdToSoChatCookie < ActiveRecord::Migration[5.2]
  def change
    change_table :so_chat_cookies do |t|
      t.belongs_to :user, required: false
    end
  end
end
