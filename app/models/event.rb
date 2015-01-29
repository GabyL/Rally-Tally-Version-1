class Event < ActiveRecord::Base

  belongs_to :user

  has_many :venues
  has_many :guests
  has_many :votes

end