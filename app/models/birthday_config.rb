# == Schema Information
#
# Table name: birthday_configs
#
#  id         :bigint           not null, primary key
#  channel    :bigint
#  message    :string
#  server     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BirthdayConfig < ApplicationRecord
    
end
