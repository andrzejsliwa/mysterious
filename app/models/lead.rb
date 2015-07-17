class Lead < ActiveRecord::Base
  has_many :notes
  	
  validates :full_name, :phone, presence: true		
end
