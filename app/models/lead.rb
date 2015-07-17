class Lead < ActiveRecord::Base
  resourcify
  has_many :notes

  validates :full_name, :phone, presence: true		
end
