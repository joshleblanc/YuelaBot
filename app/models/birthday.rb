# == Schema Information
#
# Table name: birthdays
#
#  id         :bigint           not null, primary key
#  day        :integer
#  month      :integer
#  server     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_birthdays_on_user_id  (user_id)
#
class Birthday < ApplicationRecord
    belongs_to :user
    
    def to_s
        "#{user.name}: #{month}/#{day}"
    end
end
