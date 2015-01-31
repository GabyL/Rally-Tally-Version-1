require 'twilio-ruby'

class Event < ActiveRecord::Base

  belongs_to :user

  has_many :venues
  has_many :guests
  has_many :votes


  def self.check_time
    # if time.now < 60 minutes before event.time
    #   then 
    #   twilio text that includes Venue where MAX(COUNT(vote))
    # end
    @upcoming_events = Event.where(time: 60.minutes.ago..Time.now )
    @upcoming_events.each do |event|
      if event.venue == winning_venue
        twilio_send_text
      end
    end
  end



  def winning_venue
    all_votes = Vote.where(event_id: id)

    all_votes.pluck(venue_id).group(venue_id).order('venue_id.count DESC')

    # SELECT venue_id
    # FROM votes
    # WHERE event_id = id
    # GROUP BY venue_id
    # ORDER BY COUNT(venue_id) DESC;
  end


  def twilio_send_text
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







