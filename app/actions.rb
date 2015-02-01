require 'twilio-ruby'

helpers do
  
  def current_user
    @current_user = User.find(session[:user_id])
    # for now, will be a dummy user for demo purposes
  end

  def active_page(path)
    if path == request.path_info
      return 'active'
    end
  end
end

#------------------

get '/' do # => display pg1. will link to pg2.
  erb :index
end

# ----------------------- #
### Create new event

get '/events/new' do #   display pg2
  erb :'events/new'
end

post '/events/new' do # => 'continue planning' button on pg2
  hour = params[:hour].to_i
  minutes = params[:minutes]

  if params[:am_pm] == "12"
    hour += 12
  end


  zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
  pst_time = Time.now.in_time_zone(zone)


  year = pst_time.year
  month = pst_time.month
  day = pst_time.day

  set_time = "#{year}-#{month}-#{day} #{hour}:#{minutes}:00 -0800"

  @event = Event.create(
    # user_id: current_user.id,
    title: params[:title],
    # time: params[:time]
    time: set_time.to_datetime #
    )
  redirect "/events/#{@event.id}/venues" # => go to pg3
end

# ----------------------- #
### Add venues

get '/events/:event_id/venues' do #|event_id|
  # @event_id = event_id# => display pg3. Will have a link to pg4.
  @event = Event.where(id: params[:event_id]).first
  @venues = Venue.where(event_id: params[:event_id])
  erb :'/events/venues'
end

post '/events/venues' do # => "add venue" button on pg3
  Venue.create(
    event_id: params[:event_id],
    name: params[:name]
    )
  # @venues = Venue.where(event_id: params[:event_id])
  redirect "/events/#{params[:event_id]}/venues" # => refreshes page
end

# ----------------------- #
### Add guests

get '/events/:event_id/guests' do # => display pg4. 
  @event = Event.where(id: params[:event_id]).first
  @guests = Guest.where(event_id: params[:event_id])
  erb :'/events/guests'
end

post '/events/guests' do # => "add guest" button on pg4
  area_code = params[:area_code]
  phone_first = params[:phone_first]
  phone_last = params[:phone_last]

  phone_number = "+1#{area_code}#{phone_first}#{phone_last}"

  if (/\A\+1\d{10}\Z/).match(phone_number)
    Guest.create(
      event_id: params[:event_id],
      name: params[:name],
      phone: phone_number
      )
  end
  # @guests = Guest.where(event_id: params[:event_id])
  redirect "/events/#{params[:event_id]}/guests" # => refreshes page

  # if @guest.save
  #   redirect '/events/#{params[:event_id]}/guests'
  # else
  #   :'/events/guests'
  # end

end

# ----------------------- #
### Go to confirmation

get '/events/:event_id/confirmation' do # => display pg5. Haslink to /events/[:event_id]
  @event = Event.where(id: params[:event_id]).first
  erb :'events/confirmation'
end

post '/events/confirmation' do # => "send invites" button on pg4.
  #######Twilio action!!!! Send out invites
  @event = Event.where(id: params[:event_id]).first

  zone = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
  pst_time = @event.time.in_time_zone(zone)
  ptmonth = pst_time.month.to_i
  month = nil

  case ptmonth
    when 1
      month = "January"
    when 2
      month = "February"
    when 3
      month = "March"
    when 4
      month = "April"
    when 5
      month = "May"
    when 6
      month = "June"
    when 7
      month = "July"
    when 8
      month = "August"
    when 9
      month = "September"
    when 10
      month = "October"
    when 11
      month = "November"
    when 12
      month = "December"
  end

  pthour = pst_time.hour.to_i
  am_pm = "AM"

  if pthour > 12
    hour = pthour-12
    am_pm = "PM"
  else
    hour = pthour
  end

  ptminute = pst_time.min

  if ptminute == 0
    minute = "00"
  end

  true_time = "#{hour}:#{minute} #{am_pm} on #{month} #{pst_time.day}, #{pst_time.year}"

  @event.correct_time = true_time

  account_sid = "AC6f371839daf109a9f0faf1fd39e444f9"
  auth_token = "518b385875c00eee24ef68ee70ac67e5"
  client = Twilio::REST::Client.new account_sid, auth_token

  from = "+16043371550"

  message_body = ""
  location_count = 0

  @event.venues.reverse.each do |venue|
    location_count += 1
    message_body += "'#{location_count}' for #{venue.name} "
  end

  @event.guests.each do |guest|
    client.account.messages.create(
      :from => from, 
      :to => guest.phone, 
      :body => "Hey #{guest.name}, you've been invited to #{@event.title} at #{true_time}! To vote, select #{message_body}. Reply '0' to decline."
    )
  end

  redirect "/events/#{params[:event_id]}/confirmation" # => go to pg5
end



# ----------------------- #
### Go to event details page

get '/events/:event_id' do # => display pg6. Details of event including vote count.
  @event = Event.where(id: params[:event_id]).first

  @venue_counts = []

  @event.venues.each do |venue|
    @venue_counts << [venue.name, venue.votes.count]
  end

  @venue_counts.sort_by! { |venue_count| -venue_count[1] }

  @decline_count = Vote.where(event_id: @event.id, venue_id: 0).count

  erb :'events/details'
end


# ----------------------- #
### Receive text reply
get '/sms-quickstart' do
  body = params['Body']
  from = params['From']

  guest = Guest.where(phone: from).last
  event = Event.find(guest.event_id)
  # event = Event.where(id: guest.event_id).first

  if /\d/.match(body)
    int_reply = body[/\d/].to_i

    if (int_reply <= event.venues.count) && (int_reply != 0)

      venue_index = 0
      venue_array = []

      event.venues.reverse.each do |venue|
        venue_index += 1
        venue_array << [venue, venue_index]
      end


      venue_array.each do |temp_venue|
        if temp_venue[1] == int_reply
          @venue = temp_venue[0]
        end
      end

      existing_vote = Vote.where(event_id: event.id, guest_id: guest.id).first

      if existing_vote.nil?
        Vote.create(event_id: event.id, guest_id: guest.id, venue_id: @venue.id)
      else
        existing_vote.venue_id = @venue.id
        existing_vote.save
      end

    elsif int_reply == 0
      already_voted = Vote.where(event_id: event.id, guest_id: guest.id).first
      
      if already_voted.nil?
        Vote.create(event_id: event.id, guest_id: guest.id, venue_id: 0)
      else
        already_voted.venue_id = 0
        existing_vote.save
      end

    end
  end

  twiml = Twilio::TwiML::Response.new do |r|
    if /\d/.match(body)
      if (body.to_i <= event.venues.count) && (body.to_i != 0)
        r.Message "Hi #{guest.name}! You have selected #{@venue.name}. This has been updated in the votes."
      elsif body.to_i == 0
        r.Message "Hi #{guest.name}! We are sad you can't join us. Thanks for the reply!"
      else
        r.Message "You have selected #{body}. This is not a choice, please select a number from the list above."
        end
    else
      r.Message "Please send a number from the list above or '0' to decline the invitation to #{event.title}."
    end
  end
  twiml.text # => actually sends out text to recipient
end





