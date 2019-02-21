class User < ApplicationRecord
    has_one :afk
    has_many :birthdays
end