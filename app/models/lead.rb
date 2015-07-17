class Lead < ActiveRecord::Base
  has_many :notes
  resourcify
  
  validates :full_name, :phone, presence: true		
end
