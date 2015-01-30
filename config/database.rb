configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  set :database, {
    adapter: "postgresql",
    # database: "db/db.sqlite3",
    database: 'meet_n_eat',#ENV['DATABASE_URL']
    #  export DATABASE_URL="postgres://USERNAME:PASSWORD@localhost:5432/DATABASENAME"
    
    #postgres://user3123:passkja83kd8@ec2-117-21-174-214.compute-1.amazonaws.com:6212/db982398
    username: 'emily',
    password: 'emily',
    host: 'localhost',
    port: 5432,
    min_messages: 'error'
  }

  # ActiveRecord::Base.establish_connection(
  #   adapter: 'postgresql',
  #   encoding: 'unicode',
  #   pool: 5,
  #   database: 'meet_n_eat',#ENV['DATABASE_URL']
  #   #  export DATABASE_URL="postgres://USERNAME:PASSWORD@localhost:5432/DATABASENAME"
    
  #   #postgres://user3123:passkja83kd8@ec2-117-21-174-214.compute-1.amazonaws.com:6212/db982398
  #   username: 'emily',
  #   password: 'emily',
  #   host: 'localhost',
  #   port: 5432,
  #   min_messages: 'error'
  # )


  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end
