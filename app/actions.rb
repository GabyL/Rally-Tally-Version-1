require 'twilio-ruby'

helpers do
  
  def current_user
    @current_user = User.find(session[:user_id])
    # for now, will be a dummy user for demo purposes
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
  @event = Event.create(
    # user_id: current_user.id,
    title: params[:title],
    time: params[:time]
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
  Guest.create(
    event_id: params[:event_id],
    name: params[:name],
    phone: params[:phone]
    )
  # @guests = Guest.where(event_id: params[:event_id])
  redirect "/events/#{params[:event_id]}/guests" # => refreshes page
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

  account_sid = "AC6f371839daf109a9f0faf1fd39e444f9"
  auth_token = "518b385875c00eee24ef68ee70ac67e5"
  client = Twilio::REST::Client.new account_sid, auth_token

  from = "+16043371550"

  message_body = ""
  location_count = 0

  @event.venues.each do |venue|
    location_count += 1
    message_body += "#{location_count}) #{venue.name} "
  end

  @event.guests.each do |guest|
    client.account.messages.create(
      :from => from, 
      :to => guest.phone, 
      :body => "Hey #{guest.name}, you've been invited to #{@event.title}! Please vote for a location: #{message_body}"
    )
  end

  redirect "/events/#{params[:event_id]}/confirmation" # => go to pg5
end



# ----------------------- #
### Go to event details page

get '/events/:event_id' do # => display pg6. Details of event including vote count.
  @event = Event.where(id: params[:event_id]).first
  erb :'events/details'
end



