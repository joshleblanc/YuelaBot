class User < ApplicationRecord
    has_one :afk
    has_many :birthdays
    has_many :so_chat_cookies
end