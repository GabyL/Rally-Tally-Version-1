require 'twilio-ruby'

class Event < ActiveRecord::Base

  belongs_to :user

  has_many :venues
  has_many :guests
  has_many :votes



  def self.check_votes
    # if guest.decline == false then send below
    events = Event.where(sent_text: false)
    events.each do |event|
      if event.votes.count == event.guests.count
        event.venues.each do |venue|
          @winning_venue ||= venue 
          if venue.votes.count > @winning_venue.votes.count        
            @winning_venue = venue 
          end
        end
        event.twilio_send_text(event, @winning_venue)
        event.sent_text = true
        event.save
      end
    end
  end

  def self.check_time
    upcoming_events = Event.where(time: 90.minutes.ago..Time.now )
    upcoming_events.each do |event|
      if event.sent_text == false
        event.venues.each do |venue|
          @winning_venue ||= venue 
          if venue.votes.count > @winning_venue.votes.count        
            @winning_venue = venue 
          end
        end
        event.twilio_send_text(event, @winning_venue)
        event.sent_text = true
        event.save
      end
    end
  end

# => dude this is sensitive info... hide that shit
  def twilio_send_text(event, winning_venue)
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

    event.guests.each do |guest|
      client.account.messages.create(
        :from => from, 
        :to => guest.phone, 
        :body => "Hey #{guest.name}, the finalized venue for #{event.title} is #{winning_venue.name}. See you at #{event.correct_time}!"
      )
    end
  end
  
end







