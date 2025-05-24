# == Schema Information
#
# Table name: role_colors
#
#  id         :integer          not null, primary key
#  color      :string
#  name       :string
#  server     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RoleColor < ApplicationRecord
    
end
