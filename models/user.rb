class User < ApplicationRecord
    has_one :afk
    has_one :birthday
end