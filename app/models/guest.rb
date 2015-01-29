class Guest < ActiveRecord::Base

  belongs_to :event

  has_one :vote

end