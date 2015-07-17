class Note < ActiveRecord::Base
  validates :message, :details, presence: true	
end
