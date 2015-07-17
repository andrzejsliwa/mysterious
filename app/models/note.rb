class Note < ActiveRecord::Base
  belongs_to :lead
  resourcify
  	
  validates :message, :details, presence: true	
end
