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


get '/events/new' do #   display pg2
  erb:'events/new'
end

post '/events/new' do # => 'continue planning' button on pg2
  @event = Event.create(
    user_id: current_user.id,
    title: params[:title],
    time: params[:time]
    )
  redirect "/events/#{@event.id}/venues" # => go to pg3
end

get '/events/[:event_id]/venues' do # => display pg3. Will have a link to pg4.
  erb:'events/venues'
end

post '/events/[:event_id]/venues' do # => "add venue" button on pg3
  Venue.create(
    event_id: params[:event_id],
    name: params[:name]
    )
  @venues = Venue.where(event_id: params[:event_id])
  redirect "/events/[:event_id]/venues" # => refreshes page
end

get '/events/[:event_id]/guests' do # => display pg4. 
  erb:'events/guests'
end

post '/events/[:event_id]/guests' do # => "add guest" button on pg4
  Guest.create(
    event_id: params[:event_id],
    name: params[:name],
    phone: params[:phone]
    )
  @guests = Guest.where(event_id: params[:event_id])
  redirect "/events/[:event_id]/guests" # => refreshes page
end

post '/events/[:event_id]/confirmation' do # => "send invites" button on pg4.
  #######Twilio action!!!! Send out invites
  redirect "/events/[:event_id]/confirmation" # => go to pg5
end

get '/events/[:event_id]/confirmation' do # => display pg5. Haslink to /events/[:event_id]
  erb:'events/confirmation'
end

get '/events/[:event_id]' do # => display pg6. Details of event including vote count.
  @event = Event.find(params[:id])
  erb:'events/detail'
end

