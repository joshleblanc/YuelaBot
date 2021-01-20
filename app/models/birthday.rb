class Birthday < ApplicationRecord
    belongs_to :user
    
    def to_s
        "#{user.name}: #{month}/#{day}"
    end
end