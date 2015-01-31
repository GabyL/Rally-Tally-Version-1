require 'twilio-ruby'

class Event < ActiveRecord::Base

  belongs_to :user

  has_many :venues
  has_many :guests
  has_many :votes


  def self.check_time

    @upcoming_events = Event.where(time: 60.minutes.ago..Time.now )
    @upcoming_events.each do |event|
      event.venues.each do |venue|
        @winning_venue ||= venue 
        if venue.votes.count > @winning_venue.votes.count        
          @winning_venue = venue 
        end
      end
      twilio_send_text(@winning_venue)
    end
  end


  def twilio_send_text(winning_venue)
    account_sid = "AC6f371839daf109a9f0faf1fd39e444f9"
    auth_token = "518b385875c00eee24ef68ee70ac67e5"
    client = Twilio::REST::Client.new account_sid, auth_token

    from = "+16043371550"

    message_body = ""
    # location_count = 0

    # venues.reverse.each do |venue|
    #   location_count += 1
    #   message_body += "#{location_count}) #{venue.name} "
    # end

    guests.each do |guest|
      client.account.messages.create(
        :from => from, 
        :to => guest.phone, 
        :body => "Hey #{guest.name}, the finalized venue for #{title} is #{winning_venue.name}. See you at #{time}!"
      )
    end
  end
  
end







