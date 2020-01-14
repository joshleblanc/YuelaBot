class User < ApplicationRecord
    has_one :afk
    has_many :birthdays
    has_one :so_chat_cookie
end