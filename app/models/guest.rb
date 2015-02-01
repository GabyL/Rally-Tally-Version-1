class Guest < ActiveRecord::Base

  belongs_to :event

  has_one :vote

  # validates :phone, {with: /\A\+1\d{10}\Z/, message: "not a valid phone number"}

end