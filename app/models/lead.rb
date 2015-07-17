class Lead < ActiveRecord::Base
  validates :full_name, :phone, presence: true		
end
