class Vote < ActiveRecord::Base

  belongs_to :event
  belongs_to :guest
  belongs_to :venue

end