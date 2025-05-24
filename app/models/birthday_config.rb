# == Schema Information
#
# Table name: birthday_configs
#
#  id         :integer          not null, primary key
#  server     :integer
#  channel    :integer
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BirthdayConfig < ApplicationRecord
    
end
