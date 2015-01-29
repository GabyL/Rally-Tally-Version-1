helpers do
  
  def current_user
    # for now, will be a dummy user for demo purposes
  end
end
#------------------

get '/' do # => landing page. Our user will be logged in.
  erb :index
end


get '/events/new' do # => enter title and time
  erb: 'events/new'
end

post '/events/new' do
  @event = Event.create(
    user_id: current_user.id,
    title: params[:title],
    time: params[:time]
    )
  redirect "/events/#{@event.id}"
end

get '/events/[:event_id]/venues' do
  erb: 'events/venues'
end

push '/events/[:event_id]/venues' do
  @venue = Venue.create(
    event_id: (current event id)
    name:

    )

get '/events/[:event_id]' do
  @event = Event.find(params[:id])
  erb :'events/detail'
end





/events/new - enter event title, event time, SUBMIT(button) -> create Event, redirect to 
/events/[:event_id]/venues
/events/[:event_id]/guests
/events/[:event_id]/guests
- enter invitees (name, phone) ADD ->create Invitee (list newly added guest)
/events/[:event_id]/venues
- enter location (name) ADD(button) -> create Location  (list newly added venue)
- Link SUBMIT -> redirects to   /events/[:event_id]/confirmation
    -> sends request to Twilio
/events/[:event_id]/confirmation
    -Done page - says “Your event has been created and your invitees have been notified” LINK to events/[:event_id] <--event details page
/events/[:event_id]   