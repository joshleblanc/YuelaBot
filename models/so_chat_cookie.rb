class SoChatCookie < ApplicationRecord
  belongs_to :user, required: false
end