class Note < ActiveRecord::Base
  belongs_to :lead
  	
  validates :message, :details, presence: true	
end
