configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end



configure :development do
 set :database, {
  adapter: "postgresql",
  database: DatabaseName,#ENV['DATABASE_URL']
  #  export DATABASE_URL="postgres://USERNAME:PASSWORD@localhost:5432/DATABASENAME"
  
  username: YourUsername,
  password: YourPassword,
  host: YourHost,
  port: PortNumber,
  min_messages: 'error'
  }
 set :show_exceptions, true
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end

  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end
