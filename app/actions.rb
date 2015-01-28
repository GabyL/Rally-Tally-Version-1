# helper methods below

helpers do
  
  def current_user
    # for now, will be a dummy user for demo purposes
  end


get '/' do # => landing page. Our user will be logged in.
  erb :index
end


get '/events/new' do # => 
  erb: 'events/new'
end


