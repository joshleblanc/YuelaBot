# == Schema Information
#
# Table name: role_colors
#
#  id         :bigint           not null, primary key
#  color      :string
#  name       :string
#  server     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RoleColor < ApplicationRecord
    
end
